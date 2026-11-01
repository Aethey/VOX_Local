import AVFoundation
import Foundation

final class AudioSpool: @unchecked Sendable {
  private let queue = DispatchQueue(label: "vox.audio.spool", qos: .userInitiated)
  private let engine = AVAudioEngine()
  private var writer: FileHandle?
  private(set) var url: URL
  private var total = 0
  private var lastVoice = 0
  private var meter: Double = 0
  private var failure: Error?
  private let capacity = 256 * 1024 * 1024

  init(url: URL) { self.url = url }
  func start() throws {
    let session = AVAudioSession.sharedInstance()
    try session.setCategory(.record, mode: .measurement, options: [.allowBluetoothHFP])
    try session.setActive(true)
    FileManager.default.createFile(atPath: url.path, contents: nil, attributes: [.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication])
    writer = try FileHandle(forWritingTo: url)
    let input = engine.inputNode
    let sourceFormat = input.outputFormat(forBus: 0)
    guard sourceFormat.sampleRate > 0,
          let target = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 16000, channels: 1, interleaved: false),
          let converter = AVAudioConverter(from: sourceFormat, to: target) else { throw NSError(domain: "vox", code: 1) }
    input.installTap(onBus: 0, bufferSize: 4096, format: sourceFormat) { [weak self] buffer, _ in
      guard let self, let copy = AVAudioPCMBuffer(pcmFormat: buffer.format, frameCapacity: buffer.frameLength) else { return }
      copy.frameLength = buffer.frameLength
      let src = UnsafeMutableAudioBufferListPointer(buffer.mutableAudioBufferList)
      let dst = UnsafeMutableAudioBufferListPointer(copy.mutableAudioBufferList)
      for i in 0..<src.count {
        if let s = src[i].mData, let d = dst[i].mData { memcpy(d, s, Int(src[i].mDataByteSize)) }
      }
      self.queue.async { [weak self] in
        guard let self, self.failure == nil else { return }
        let frames = AVAudioFrameCount(Double(copy.frameLength) * 16000 / sourceFormat.sampleRate + 32)
        guard let output = AVAudioPCMBuffer(pcmFormat: target, frameCapacity: frames) else { return }
        var supplied = false
        var conversionError: NSError?
        converter.convert(to: output, error: &conversionError) { _, status in
          if supplied { status.pointee = .noDataNow; return nil }
          supplied = true; status.pointee = .haveData; return copy
        }
        if let error = conversionError { self.failure = error; return }
        guard let samples = output.floatChannelData?[0], output.frameLength > 0 else { return }
        let count = Int(output.frameLength)
        if (self.total + count) * 4 > self.capacity { self.failure = NSError(domain: "vox.audio.capacity", code: 2); return }
        var energy: Float = 0
        for i in 0..<count { energy += samples[i] * samples[i] }
        let rms = sqrt(energy / Float(count))
        do {
          try self.writer?.write(contentsOf: Data(bytes: samples, count: count * 4))
          self.total += count
          if rms > 0.008 { self.lastVoice = self.total }
          self.meter = min(1, Double(rms) * 12)
        } catch { self.failure = error }
      }
    }
    engine.prepare()
    do { try engine.start() } catch { engine.inputNode.removeTap(onBus: 0); throw error }
  }
  func snapshot() throws -> (count: Int, lastVoice: Int, level: Double) {
    try queue.sync { if let failure { throw failure }; return (total, lastVoice, meter) }
  }
  func read(offset: Int, count: Int) throws -> [Float] {
    let reader = try FileHandle(forReadingFrom: url)
    defer { try? reader.close() }
    try reader.seek(toOffset: UInt64(offset * 4))
    let data = try reader.read(upToCount: count * 4) ?? Data()
    return data.withUnsafeBytes { Array($0.bindMemory(to: Float.self)) }
  }
  func stop() {
    engine.stop(); engine.inputNode.removeTap(onBus: 0)
    queue.sync { try? writer?.synchronize(); try? writer?.close(); writer = nil }
    try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
  }
}

struct JournalSegment: Codable {
  let sessionId: String
  let sequence: Int64
  let start: Double
  let end: Double
  let text: String
  var native: NativeSegment { NativeSegment(sessionId: sessionId, sequence: sequence, start: start, end: end, text: text) }
}

final class SegmentJournal {
  let root: URL
  init(root: URL) throws { self.root = root; try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true) }
  func path(_ sessionId: String) throws -> URL {
    guard !sessionId.isEmpty, sessionId.count < 100, sessionId.allSatisfy({ $0.isNumber || $0 == "-" }) else { throw NSError(domain: "vox.session", code: 1) }
    return root.appendingPathComponent(sessionId + ".jsonl")
  }
  func append(_ segment: JournalSegment) throws {
    let url = try path(segment.sessionId)
    if !FileManager.default.fileExists(atPath: url.path) { FileManager.default.createFile(atPath: url.path, contents: nil, attributes: [.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication]) }
    let handle = try FileHandle(forWritingTo: url)
    defer { try? handle.close() }
    try handle.seekToEnd()
    var data = try JSONEncoder().encode(segment); data.append(10)
    try handle.write(contentsOf: data)
    try handle.synchronize()
  }
  func replay(_ sessionId: String, after: Int64) throws -> [NativeSegment] {
    let url = try path(sessionId)
    guard FileManager.default.fileExists(atPath: url.path) else { return [] }
    let handle = try FileHandle(forReadingFrom: url)
    defer { try? handle.close() }
    var buffer = Data(), result: [NativeSegment] = []
    while let data = try handle.read(upToCount: 65536), !data.isEmpty {
      buffer.append(data)
      while let newline = buffer.firstIndex(of: 10) {
        let line = buffer.prefix(upTo: newline)
        if let segment = try? JSONDecoder().decode(JournalSegment.self, from: line), segment.sequence > after { result.append(segment.native) }
        buffer.removeSubrange(...newline)
        if result.count >= 200 { return result }
      }
      if buffer.count > 65536 { throw NSError(domain: "vox.journal", code: 1) }
    }
    return result
  }
}
