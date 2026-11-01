import Foundation

/// A decode owns a fixed physical audio range. Inference timestamps never move it.
struct TranscriptionWindow {
  static let sampleRate = 16000
  static let maximumSamples = 20 * sampleRate
  let start: Int
  let end: Int
  let decoderEnd: Int
  let isFinal: Bool

  static func next(start: Int, count: Int, lastVoice: Int, lastDecoded: Int, stopped: Bool) -> TranscriptionWindow? {
    guard count > start, lastVoice > start else { return nil }
    let available = count - start
    let final = stopped || available >= maximumSamples || count - lastVoice >= 11200
    guard final || (available >= sampleRate && count - lastDecoded >= sampleRate) else { return nil }
    let end = start + min(available, maximumSamples)
    return TranscriptionWindow(start: start, end: end,
                               decoderEnd: min(end, lastVoice + 4800), isFinal: final)
  }
}
