import XCTest
@testable import DenTime

final class FriendTests: XCTestCase {
    func testCodableRoundtrip() throws {
        let original = Friend(
            name: "Alex",
            timezoneIdentifier: "Europe/Berlin",
            groupName: "Pack",
            colorHex: "#0FACED",
            sortOrder: 3
        )
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Friend.self, from: data)
        XCTAssertEqual(decoded, original)
    }

    func testTimezoneResolution() {
        let f = Friend(name: "Sam", timezoneIdentifier: "Asia/Tokyo")
        XCTAssertEqual(f.timezone.identifier, "Asia/Tokyo")
    }

    func testTimezoneFallback() {
        let f = Friend(name: "X", timezoneIdentifier: "Bogus/Zone")
        XCTAssertEqual(f.timezone.identifier, TimeZone.current.identifier)
    }

    func testCityDerivation() {
        XCTAssertEqual(Friend(name: "A", timezoneIdentifier: "America/New_York").city, "New York")
        XCTAssertEqual(Friend(name: "B", timezoneIdentifier: "Europe/Berlin").city, "Berlin")
    }
}

final class TimeStatusTests: XCTestCase {
    func testWorkingHourInWindow() {
        XCTAssertEqual(TimeStatus.classify(hour: 10, workingStart: 9, workingEnd: 18), .working)
    }

    func testEdgeBeforeStart() {
        XCTAssertEqual(TimeStatus.classify(hour: 8, workingStart: 9, workingEnd: 18), .edge)
    }

    func testEdgeAfterEnd() {
        XCTAssertEqual(TimeStatus.classify(hour: 18, workingStart: 9, workingEnd: 18), .edge)
    }

    func testSleep() {
        XCTAssertEqual(TimeStatus.classify(hour: 3, workingStart: 9, workingEnd: 18), .sleep)
    }
}
