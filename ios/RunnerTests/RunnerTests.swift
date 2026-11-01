import Foundation
import XCTest
@testable import Runner

final class RunnerTests: XCTestCase {
  private var root: URL!
  override func setUpWithError() throws {
    root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
  }
  override func tearDownWithError() throws { try FileManager.default.removeItem(at: root) }
  func testJournalRejectsTraversal() throws {
    let journal = try SegmentJournal(root: root)
    XCTAssertThrowsError(try journal.path("../private"))
  }
  func testJournalReplayIsPagedAndOrdered() throws {
    let journal = try SegmentJournal(root: root)
    for i in 1...205 {
      try journal.append(JournalSegment(sessionId: "123-456", sequence: Int64(i), start: Double(i), end: Double(i+1), text: "synthetic fixture"))
    }
    let first = try journal.replay("123-456", after: 0)
    XCTAssertEqual(first.count, 200)
    let second = try journal.replay("123-456", after: first.last!.sequence)
    XCTAssertEqual(second.map(\.sequence), [201, 202, 203, 204, 205])
  }
  func testAudioReadHonorsWindowBounds() throws {
    let url = root.appendingPathComponent("fixture.pcm")
    let samples: [Float] = [0.1, 0.2, 0.3, 0.4]
    try samples.withUnsafeBytes { try Data($0).write(to: url) }
    let spool = AudioSpool(url: url)
    XCTAssertEqual(try spool.read(offset: 1, count: 2), [0.2, 0.3])
  }
}
