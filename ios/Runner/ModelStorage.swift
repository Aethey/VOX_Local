import Foundation

/// Model references are relative to Application Support, never to an install container UUID.
struct ModelStorage {
  static let repository = "argmaxinc/whisperkit-coreml"
  let root: URL
  private let manager = FileManager.default

  static func variant(_ id: String) throws -> String {
    switch id {
    case "turbo": return "openai_whisper-large-v3-v20240930_626MB"
    case "small": return "openai_whisper-small"
    default: throw NSError(domain: "vox.model.unknown", code: 1)
    }
  }

  private func relativeURL(_ path: String) -> URL? {
    guard !path.isEmpty, !path.hasPrefix("/") else { return nil }
    let base = root.standardizedFileURL.resolvingSymlinksInPath()
    let candidate = base.appendingPathComponent(path).standardizedFileURL.resolvingSymlinksInPath()
    guard candidate.path.hasPrefix(base.path + "/") else { return nil }
    return candidate
  }
  private func complete(_ folder: URL) -> Bool {
    ["MelSpectrogram.mlmodelc", "AudioEncoder.mlmodelc", "TextDecoder.mlmodelc"].allSatisfy {
      manager.fileExists(atPath: folder.appendingPathComponent($0).path)
    }
  }
  private func marker(_ id: String) -> URL { root.appendingPathComponent(id + ".path") }
  private func canonical(_ id: String) throws -> URL {
    root.appendingPathComponent("models/models/\(Self.repository)/\(try Self.variant(id))")
  }

  func location(_ id: String) throws -> URL? {
    let name = try Self.variant(id)
    var candidates: [URL] = []
    if let saved = try? String(contentsOf: marker(id), encoding: .utf8) {
      let path = saved.trimmingCharacters(in: .whitespacesAndNewlines)
      if let relative = relativeURL(path) { candidates.append(relative) }
      // Recover markers written by previous builds, even after a container relocation.
      if let boundary = path.range(of: "/VoxSpeech/", options: .backwards),
         let rebased = relativeURL(String(path[boundary.upperBound...])) {
        candidates.append(rebased)
      }
    }
    candidates.append(try canonical(id))
    for candidate in candidates where candidate.lastPathComponent == name && complete(candidate) {
      try? register(candidate, for: id)
      return candidate
    }
    return nil
  }

  func register(_ folder: URL, for id: String) throws {
    let name = try Self.variant(id)
    let base = root.standardizedFileURL.resolvingSymlinksInPath()
    let candidate = folder.standardizedFileURL.resolvingSymlinksInPath()
    guard candidate.path.hasPrefix(base.path + "/"), candidate.lastPathComponent == name, complete(candidate) else {
      throw NSError(domain: "vox.model.incomplete", code: 1)
    }
    let relative = String(candidate.path.dropFirst(base.path.count + 1))
    if (try? String(contentsOf: marker(id), encoding: .utf8)) != relative {
      try relative.write(to: marker(id), atomically: true, encoding: .utf8)
    }
  }

  func delete(_ id: String) throws {
    let name = try Self.variant(id)
    let folder = try location(id) ?? canonical(id)
    let cache = root.appendingPathComponent("models/models/\(Self.repository)/.cache/huggingface/download/\(name)")
    for path in [folder, cache, marker(id)] where manager.fileExists(atPath: path.path) {
      try manager.removeItem(at: path)
    }
  }
}
