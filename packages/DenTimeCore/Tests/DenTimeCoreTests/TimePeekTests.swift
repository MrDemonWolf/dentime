import Foundation
import XCTest

@testable import DenTimeCore

final class TimePeekTests: XCTestCase {
    private let chicagoID = "America/Chicago"
    private let aucklandID = "Pacific/Auckland"

    // MARK: - Scrubbing

    func testScrubMovesTheInstantAndClampsToTheRange() {
        let base = utc(2026, 8, 6, 1)
        XCTAssertEqual(TimePeek.scrubbedInstant(from: base, offsetMinutes: 0), base)
        XCTAssertEqual(
            TimePeek.scrubbedInstant(from: base, offsetMinutes: 90),
            base.addingTimeInterval(90 * 60)
        )
        XCTAssertEqual(
            TimePeek.scrubbedInstant(from: base, offsetMinutes: -90),
            base.addingTimeInterval(-90 * 60)
        )
        XCTAssertEqual(
            TimePeek.scrubbedInstant(from: base, offsetMinutes: 5_000),
            base.addingTimeInterval(720 * 60),
            "clamped to +12h"
        )
        XCTAssertEqual(
            TimePeek.scrubbedInstant(from: base, offsetMinutes: -5_000),
            base.addingTimeInterval(-720 * 60),
            "clamped to -12h"
        )
    }

    // MARK: - Rendering a row

    func testRowCarriesTimeWeekdayOffsetAndDayDelta() {
        // Wed 5 Aug 2026, 20:00 in Chicago — which is already Thu 6 Aug in Auckland.
        let instant = utc(2026, 8, 6, 1)
        let chicago = zone(chicagoID)
        let auckland = zone(aucklandID)

        let home = TimePeek.row(
            for: chicago, at: instant, relativeTo: chicago,
            format: .twelveHour, calendar: testCalendar
        )
        XCTAssertEqual(home.hour, 20)
        XCTAssertEqual(home.minute, 0)
        XCTAssertEqual(home.weekday, 4)
        XCTAssertEqual(home.weekdaySymbol, "Wed")
        XCTAssertEqual(home.dayDelta, 0)
        XCTAssertEqual(home.relativeOffsetMinutes, 0)
        XCTAssertEqual(home.formattedTime, "8:00 PM")
        XCTAssertFalse(home.isNight)
        XCTAssertEqual(home.id, chicagoID)

        let away = TimePeek.row(
            for: auckland, at: instant, relativeTo: chicago,
            format: .twentyFourHour, calendar: testCalendar
        )
        XCTAssertEqual(away.hour, 13)
        XCTAssertEqual(away.weekday, 5)
        XCTAssertEqual(away.weekdaySymbol, "Thu")
        XCTAssertEqual(away.dayDelta, 1, "already tomorrow in Auckland")
        XCTAssertEqual(away.relativeOffsetMinutes, 1_020)
        XCTAssertEqual(away.offsetLabel, "UTC+12")
        XCTAssertEqual(away.formattedTime, "13:00")
    }

    func testRowsPreserveTheOrderTheyWereAskedFor() {
        let instant = utc(2026, 8, 6, 1)
        let zones = [zone(aucklandID), zone(chicagoID), zone("Europe/London")]
        let rows = TimePeek.rows(
            for: zones, at: instant, relativeTo: zone(chicagoID), calendar: testCalendar
        )
        XCTAssertEqual(rows.map(\.timeZoneIdentifier), zones.map(\.identifier))
        XCTAssertEqual(Set(rows.map(\.instant)), [instant], "every row renders the same instant")
    }

    // MARK: - Scrubbing across DST

    /// A sixty-minute scrub across spring-forward moves the wall clock two hours. If the
    /// scrubber ever renders 02:30 here, the maths went through 24-hour arithmetic.
    func testScrubbingAcrossSpringForwardSkipsTheMissingHour() {
        let chicago = zone(chicagoID)
        let base = utc(2026, 3, 8, 7, 30) // 01:30 CST

        let before = TimePeek.row(
            for: chicago, at: base, relativeTo: chicago, calendar: testCalendar
        )
        XCTAssertEqual(before.hour, 1)
        XCTAssertEqual(before.minute, 30)

        let after = TimePeek.row(
            for: chicago,
            at: TimePeek.scrubbedInstant(from: base, offsetMinutes: 60),
            relativeTo: chicago,
            calendar: testCalendar
        )
        XCTAssertEqual(after.hour, 3, "02:30 does not exist; the clock lands on 03:30")
        XCTAssertEqual(after.minute, 30)
        XCTAssertEqual(after.dayDelta, 0)
    }

    /// The wrong-day bug, caught directly: one hour of scrubbing rolls Chicago into a new
    /// calendar day while Auckland stays put, so `dayDelta` has to fall from +1 to 0.
    func testScrubbingCanCrossMidnightInOneZoneOnly() {
        let chicago = zone(chicagoID)
        let auckland = zone(aucklandID)
        let base = utc(2026, 8, 6, 4, 30) // Wed 23:30 in Chicago, Thu 16:30 in Auckland

        let beforeHome = TimePeek.row(
            for: chicago, at: base, relativeTo: chicago, calendar: testCalendar
        )
        let beforeAway = TimePeek.row(
            for: auckland, at: base, relativeTo: chicago, calendar: testCalendar
        )
        XCTAssertEqual(beforeHome.hour, 23)
        XCTAssertEqual(beforeHome.weekdaySymbol, "Wed")
        XCTAssertTrue(beforeHome.isNight)
        XCTAssertEqual(beforeAway.dayDelta, 1)
        XCTAssertFalse(beforeAway.isNight)

        let scrubbed = TimePeek.scrubbedInstant(from: base, offsetMinutes: 60)
        let afterHome = TimePeek.row(
            for: chicago, at: scrubbed, relativeTo: chicago, calendar: testCalendar
        )
        let afterAway = TimePeek.row(
            for: auckland, at: scrubbed, relativeTo: chicago, calendar: testCalendar
        )
        XCTAssertEqual(afterHome.hour, 0)
        XCTAssertEqual(afterHome.weekdaySymbol, "Thu", "Chicago rolled over to Thursday")
        XCTAssertEqual(afterAway.weekdaySymbol, "Thu", "Auckland was already on Thursday")
        XCTAssertEqual(afterAway.dayDelta, 0, "the zones are now on the same calendar day")
    }

    // MARK: - Night window

    func testNightWindowWrapsAroundMidnight() {
        XCTAssertTrue(TimePeek.isNightHour(22))
        XCTAssertTrue(TimePeek.isNightHour(23))
        XCTAssertTrue(TimePeek.isNightHour(0))
        XCTAssertTrue(TimePeek.isNightHour(6))
        XCTAssertFalse(TimePeek.isNightHour(7))
        XCTAssertFalse(TimePeek.isNightHour(12))
        XCTAssertFalse(TimePeek.isNightHour(21))
    }

    // MARK: - Time format

    func testTwelveHourFormatHandlesMidnightAndNoon() {
        XCTAssertEqual(TimeFormat.twelveHour.string(hour: 0, minute: 0), "12:00 AM")
        XCTAssertEqual(TimeFormat.twelveHour.string(hour: 12, minute: 0), "12:00 PM")
        XCTAssertEqual(TimeFormat.twelveHour.string(hour: 9, minute: 5), "9:05 AM")
        XCTAssertEqual(TimeFormat.twelveHour.string(hour: 21, minute: 5), "9:05 PM")
    }

    func testTwentyFourHourFormatIsZeroPadded() {
        XCTAssertEqual(TimeFormat.twentyFourHour.string(hour: 0, minute: 0), "00:00")
        XCTAssertEqual(TimeFormat.twentyFourHour.string(hour: 9, minute: 5), "09:05")
        XCTAssertEqual(TimeFormat.twentyFourHour.string(hour: 23, minute: 59), "23:59")
    }

    // MARK: - Slots

    func testSlotRendersInEachParticipantsOwnZone() {
        let chicago = zone(chicagoID)
        let auckland = zone(aucklandID)
        let slot = MeetupSlot(startsAtUTC: utc(2026, 8, 6, 1), durationMinutes: 120)

        XCTAssertEqual(slot.endsAtUTC, utc(2026, 8, 6, 3))

        let host = slot.peekRow(in: chicago, relativeTo: chicago, calendar: testCalendar)
        let guest = slot.peekRow(in: auckland, relativeTo: chicago, calendar: testCalendar)
        XCTAssertEqual(host.hour, 20)
        XCTAssertEqual(guest.hour, 13)
        XCTAssertEqual(guest.dayDelta, 1, "the guest needs to see it lands on their Thursday")
    }
}
