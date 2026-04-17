import XCTest
@testable import DenTimeCore

final class FutureTimeCalculatorTests: XCTestCase {
    func testOffsetHoursForDifferentZones() {
        let chicago = RosterEntry(id: "1", displayName: "Nat", timezone: "America/Chicago")
        let london = RosterEntry(id: "2", displayName: "Kai", timezone: "Europe/London")
        let instant = ISO8601DateFormatter().date(from: "2026-06-15T18:00:00Z")!

        let peeks = FutureTimeCalculator.peek(
            yourInstant: instant,
            yourTimezone: TimeZone(identifier: "America/Chicago")!,
            roster: [chicago, london]
        )

        XCTAssertEqual(peeks[0].offsetHours, 0)
        XCTAssertEqual(peeks[1].offsetHours, 6)
    }

    func testFriendCodeRoundTrip() {
        XCTAssertEqual(FriendCode.format("WLFX4X7K"), "WLFX-4X7K")
        XCTAssertEqual(FriendCode.normalize("wlfx-4x7k"), "WLFX4X7K")
        XCTAssertEqual(FriendCode.normalize("wl.fx 4x7k!"), "WLFX4X7K")
    }
}
