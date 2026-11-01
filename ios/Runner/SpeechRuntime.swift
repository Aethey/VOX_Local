import AVFoundation
import Flutter
import Foundation
import WhisperKit
import Network

actor SpeechRuntime: SpeechHostApi {
  private let flutter: SpeechFlutterApi
  private let monitor = NWPathMonitor()
  private let root: URL
  private let modelStorage: ModelStorage
  private var pipe: WhisperKit?
  private var selected: String?
  private var spool: AudioSpool?
  private var loop: Task<Void, Never>?
  private var operation = false
  private var stopping = false
  private var interruption: NSObjectProtocol?

  init(messenger: FlutterBinaryMessenger) {
    flutter = SpeechFlutterApi(binaryMessenger: messenger)
    let directory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("VoxSpeech")
    root = directory
    modelStorage = ModelStorage(root: directory)
    try? FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
    var excluded = root
    var values = URLResourceValues(); values.isExcludedFromBackup = true
    try? excluded.setResourceValues(values)
    monitor.pathUpdateHandler = { [weak self] path in
      Task { await self?.emit(NativeEvent(kind: "network", phase: path.status == .satisfied ? "online" : "offline")) }
    }
    monitor.start(queue: DispatchQueue(label: "vox.network"))
  }
  private func emit(_ event: NativeEvent) async { try? await flutter.onEvent(event: event) }
  private func variant(_ id: String) throws -> String { try ModelStorage.variant(id) }
  private func location(_ id: String) throws -> URL? { try modelStorage.location(id) }
  func models() async throws -> [NativeModel] {
    await emit(NativeEvent(kind: "network", phase: monitor.currentPath.status == .satisfied ? "online" : "offline"))
    return try ["turbo", "small"].map { NativeModel(id: $0, installed: try location($0) != nil) }
  }
  func download(modelId: String) async throws {
    guard spool == nil, !operation else { throw NSError(domain: "vox.busy", code: 1) }
    operation = true; defer { operation = false }
    let name = try variant(modelId)
    let folder = try await WhisperKit.download(variant: name, downloadBase: root.appendingPathComponent("models"), from: ModelStorage.repository) { [weak self] progress in
      Task { await self?.emit(NativeEvent(kind: "model", modelId: modelId, phase: "downloading", progress: progress.fractionCompleted)) }
    }
    await emit(NativeEvent(kind: "model", modelId: modelId, phase: "verifying"))
    try modelStorage.register(folder, for: modelId)
    await emit(NativeEvent(kind: "model", modelId: modelId, phase: "installed", progress: 1))
  }
  func load(modelId: String) async throws {
    guard spool == nil, !operation, let folder = try location(modelId) else { throw NSError(domain: "vox.model.unavailable", code: 1) }
    operation = true; defer { operation = false }
    if selected == modelId, pipe != nil { return }
    await pipe?.unloadModels(); pipe = nil; selected = nil
    let config = WhisperKitConfig(modelFolder: folder.path, tokenizerFolder: root.appendingPathComponent("tokenizers"), verbose: false, prewarm: true, load: true, download: false)
    pipe = try await WhisperKit(config)
    selected = modelId
  }
  func delete(modelId: String) async throws {
    guard spool == nil, !operation else { throw NSError(domain: "vox.busy", code: 1) }
    operation = true; defer { operation = false }
    if selected == modelId { await pipe?.unloadModels(); pipe = nil; selected = nil }
    try modelStorage.delete(modelId)
  }
  func start(sessionId: String, language: String, afterSequence: Int64, offset: Double) async throws {
    guard pipe != nil, spool == nil, !operation else { throw NSError(domain: "vox.notready", code: 1) }
    guard afterSequence >= 0, offset.isFinite, offset >= 0 else { throw NSError(domain: "vox.session", code: 2) }
    let granted = await withCheckedContinuation { continuation in AVAudioSession.sharedInstance().requestRecordPermission { continuation.resume(returning: $0) } }
    guard granted else { throw NSError(domain: "vox.permission", code: 1) }
    let journal = try SegmentJournal(root: root.appendingPathComponent("transcripts"))
    _ = try journal.path(sessionId)
    let capture = AudioSpool(url: root.appendingPathComponent(sessionId + ".pcm"))
    try capture.start(); spool = capture; stopping = false
    interruption = NotificationCenter.default.addObserver(forName: AVAudioSession.interruptionNotification, object: nil, queue: nil) { [weak self] _ in
      Task { await self?.interrupt(sessionId: sessionId) }
    }
    loop = Task { await self.process(capture, journal: journal, sessionId: sessionId, language: language, afterSequence: afterSequence, offset: offset) }
  }
  private func interrupt(sessionId: String) async {
    spool?.stop(); stopping = true
    await emit(NativeEvent(kind: "error", sessionId: sessionId, text: "audioInterrupted"))
  }
  private func process(_ capture: AudioSpool, journal: SegmentJournal, sessionId: String, language: String, afterSequence: Int64, offset: Double) async {
    var cursor = 0, previousSize = 0
    // A resumed session keeps numbering and time continuous with stored segments.
    var sequence: Int64 = afterSequence, revision: Int64 = 0
    do {
      while !Task.isCancelled {
        let snapshot = try capture.snapshot()
        await emit(NativeEvent(kind: "level", sessionId: sessionId, level: snapshot.level))
        let available = snapshot.count - cursor
        if available <= 0 { if stopping { break }; try await Task.sleep(nanoseconds: 250_000_000); continue }
        if snapshot.lastVoice <= cursor {
          cursor = snapshot.count
          if stopping { break }; try await Task.sleep(nanoseconds: 250_000_000); continue
        }
        // Freeze finality before awaiting inference: stop may arrive while it runs.
        guard let window = TranscriptionWindow.next(start: cursor, count: snapshot.count,
                                                    lastVoice: snapshot.lastVoice, lastDecoded: previousSize,
                                                    stopped: stopping) else {
          try await Task.sleep(nanoseconds: 250_000_000); continue
        }
        let audio = try capture.read(offset: window.start, count: window.decoderEnd - window.start)
        previousSize = snapshot.count
        guard let pipe else { break }
        let options = DecodingOptions(language: language == "auto" ? nil : language, temperatureFallbackCount: 1, usePrefillPrompt: language != "auto", detectLanguage: language == "auto", skipSpecialTokens: true, wordTimestamps: false, concurrentWorkerCount: 1)
        let results = try await pipe.transcribe(audioArray: audio, decodeOptions: options)
        let text = results.flatMap(\.segments).map(\.text).joined().trimmingCharacters(in: .whitespacesAndNewlines)
        revision += 1
        if window.isFinal {
          var committed: [NativeSegment] = []
          if !text.isEmpty {
            sequence += 1
            let item = JournalSegment(sessionId: sessionId, sequence: sequence,
                                      start: offset + Double(window.start) / 16000,
                                      end: offset + Double(window.end) / 16000, text: text)
            try journal.append(item)
            committed.append(item.native)
          }
          cursor = window.end
          await emit(NativeEvent(kind: "transcript", sessionId: sessionId, text: "", segments: committed, revision: revision))
        } else {
          await emit(NativeEvent(kind: "transcript", sessionId: sessionId, text: text, segments: [], revision: revision))
        }
      }
      try? FileManager.default.removeItem(at: capture.url)
    } catch {
      capture.stop(); stopping = true
      await emit(NativeEvent(kind: "error", sessionId: sessionId, text: "speechProcessingPaused"))
    }
  }
  func stop() async throws {
    spool?.stop(); stopping = true
    await loop?.value
    if let interruption { NotificationCenter.default.removeObserver(interruption) }
    interruption = nil; loop = nil; spool = nil
  }
  func deleteSession(sessionId: String) async throws {
    guard spool == nil, !sessionId.isEmpty, sessionId.count < 100,
          sessionId.allSatisfy({ $0.isNumber || $0 == "-" }) else { throw NSError(domain: "vox.session.busy", code: 1) }
    let paths = [root.appendingPathComponent("transcripts").appendingPathComponent(sessionId + ".jsonl"),
                 root.appendingPathComponent(sessionId + ".pcm")]
    for path in paths where FileManager.default.fileExists(atPath: path.path) { try FileManager.default.removeItem(at: path) }
  }
  func replay(sessionId: String, afterSequence: Int64) async throws -> [NativeSegment] { try SegmentJournal(root: root.appendingPathComponent("transcripts")).replay(sessionId, after: afterSequence) }
}
