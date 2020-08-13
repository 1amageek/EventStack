import XCTest
@testable import EventStack

final class EventStackTests: XCTestCase {
    func testNumberOfLimit() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Stacker.shared.numberOfLimit, 200)
    }

    static var allTests = [
        ("testNumberOfLimit", testNumberOfLimit),
    ]
}
