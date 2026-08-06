import Foundation
import XCTest

@testable import DenTimeCore

/// DST is the one thing that can make DenTime lie to someone about which evening a plan
/// falls on, so these tests lean on the transitions hard rather than sampling mid-season.
///
/// 2026 reference dates used throughout:
/// - US DST starts Sun 8 Mar 2026 02:00 local, ends Sun 1 Nov 2026 02:00 local
/// - EU DST starts Sun 29 Mar 2026 01:00 UTC — three weeks after the US
/// - Lord Howe DST ends Sun 5 Apr 2026 and starts Sun 4 Oct 2026
final class TimeZoneResolverTests: XCTestCase {
    // MARK: - Offsets across a transition

    func testChicagoOffsetChangesAcrossSpringForward() {
        let chicago = zone("America/Chicago")
        // 01:00 local, still CST
        XCTAssertEqual(TimeZoneResolver.offsetSeconds(for: chicago, at: utc(2026, 3, 8, 7)), -21_600)
        // 03:00 local, now CDT
        XCTAssertEqual(TimeZoneResolver.offsetSeconds(for: chicago, at: utc(2026, 3, 8, 9)), -18_000)
    }

    func testChicagoOffsetChangesAcrossFallBack() {
        let chicago = zone("America/Chicago")
        // 00:00 local, still CDT
        XCTAssertEqual(TimeZoneResolver.offsetSeconds(for: chicago, at: utc(2026, 11, 1, 5)), -18_000)
        // 01:00 local the second time around, now CST
        XCTAssertEqual(TimeZoneResolver.offsetSeconds(for: chicago, at: utc(2026, 11, 1, 7)), -21_600)
    }

    /// The EU and the US do not move together. Between 8 and 29 March the usual six-hour
    /// gap between Chicago and London is only five, and anything that hard-codes the
    /// normal gap gets the meetup an hour wrong for three weeks a year.
    func testEuropeAndAmericaDoNotShiftOnTheSameDate() {
        let chicago = zone("America/Chicago")
        let london = zone("Europe/London")

        let january = utc(2026, 1, 15, 12)
        XCTAssertEqual(
            TimeZoneResolver.offsetMinutes(for: london, relativeTo: chicago, at: january),
            360
        )

        let betweenTransitions = utc(2026, 3, 15, 12)
        XCTAssertEqual(
            TimeZoneResolver.offsetMinutes(for: london, relativeTo: chicago, at: betweenTransitions),
            300,
            "Chicago is on CDT but London is still on GMT for three weeks"
        )

        let april = utc(2026, 4, 15, 12)
        XCTAssertEqual(
            TimeZoneResolver.offsetMinutes(for: london, relativeTo: chicago, at: april),
            360
        )
    }

    /// Lord Howe shifts by thirty minutes, not an hour. Anything assuming DST is always
    /// 3600 seconds breaks here.
    func testLordHoweShiftsByThirtyMinutes() {
        let lordHowe = zone("Australia/Lord_Howe")
        let standard = TimeZoneResolver.offsetSeconds(for: lordHowe, at: utc(2026, 7, 1, 0))
        let daylight = TimeZoneResolver.offsetSeconds(for: lordHowe, at: utc(2026, 1, 1, 0))
        XCTAssertEqual(standard, 37_800, "UTC+10:30 standard")
        XCTAssertEqual(daylight, 39_600, "UTC+11:00 in daylight time")
        XCTAssertEqual(daylight - standard, 1_800)
    }

    /// Southern-hemisphere DST runs opposite the north.
    func testAucklandIsOnDaylightTimeDuringTheNorthernWinter() {
        let auckland = zone("Pacific/Auckland")
        XCTAssertEqual(TimeZoneResolver.offsetSeconds(for: auckland, at: utc(2026, 1, 15, 0)), 46_800)
        XCTAssertEqual(TimeZoneResolver.offsetSeconds(for: auckland, at: utc(2026, 7, 15, 0)), 43_200)
        XCTAssertTrue(TimeZoneResolver.isDaylightSavingTime(for: auckland, at: utc(2026, 1, 15, 0)))
        XCTAssertFalse(TimeZoneResolver.isDaylightSavingTime(for: auckland, at: utc(2026, 7, 15, 0)))
    }

    // MARK: - Offset labels

    func testOffsetLabelHandlesWholeHalfAndQuarterHourZones() {
        let instant = utc(2026, 1, 15, 12)
        XCTAssertEqual(
            TimeZoneResolver.offsetLabel(for: zone("America/Chicago"), at: instant),
            "UTC\u{2212}6"
        )
        XCTAssertEqual(TimeZoneResolver.offsetLabel(for: zone("Europe/London"), at: instant), "UTC")
        XCTAssertEqual(
            TimeZoneResolver.offsetLabel(for: zone("Asia/Kolkata"), at: instant),
            "UTC+5:30"
        )
        XCTAssertEqual(
            TimeZoneResolver.offsetLabel(for: zone("Asia/Kathmandu"), at: instant),
            "UTC+5:45"
        )
        XCTAssertEqual(
            TimeZoneResolver.offsetLabel(for: zone("Pacific/Marquesas"), at: instant),
            "UTC\u{2212}9:30"
        )
    }

    func testOffsetLabelFollowsAZoneThroughItsOwnTransition() {
        let chicago = zone("America/Chicago")
        XCTAssertEqual(
            TimeZoneResolver.offsetLabel(for: chicago, at: utc(2026, 3, 8, 7)),
            "UTC\u{2212}6"
        )
        XCTAssertEqual(
            TimeZoneResolver.offsetLabel(for: chicago, at: utc(2026, 3, 8, 9)),
            "UTC\u{2212}5"
        )
    }

    // MARK: - Wall times that do not exist, or exist twice

    func testSpringForwardSkipsAnHourOfWallClockTime() {
        let chicago = zone("America/Chicago")
        XCTAssertTrue(
            TimeZoneResolver.wallTimeExists(
                localComponents(2026, 3, 8, 1, 30), in: chicago, calendar: testCalendar
            )
        )
        XCTAssertFalse(
            TimeZoneResolver.wallTimeExists(
                localComponents(2026, 3, 8, 2, 30), in: chicago, calendar: testCalendar
            ),
            "02:30 never happens on the morning clocks go forward"
        )
        XCTAssertTrue(
            TimeZoneResolver.wallTimeExists(
                localComponents(2026, 3, 8, 3, 30), in: chicago, calendar: testCalendar
            )
        )
        XCTAssertTrue(
            TimeZoneResolver.wallTimeExists(
                localComponents(2026, 3, 9, 2, 30), in: chicago, calendar: testCalendar
            ),
            "the same wall time exists perfectly well the next day"
        )
    }

    func testFallBackRepeatsAnHourOfWallClockTime() {
        let chicago = zone("America/Chicago")
        XCTAssertTrue(
            TimeZoneResolver.wallTimeIsAmbiguous(
                localComponents(2026, 11, 1, 1, 30), in: chicago, calendar: testCalendar
            ),
            "01:30 happens twice on the morning clocks go back"
        )
        XCTAssertFalse(
            TimeZoneResolver.wallTimeIsAmbiguous(
                localComponents(2026, 11, 1, 3, 30), in: chicago, calendar: testCalendar
            )
        )
        XCTAssertFalse(
            TimeZoneResolver.wallTimeIsAmbiguous(
                localComponents(2026, 6, 1, 1, 30), in: chicago, calendar: testCalendar
            )
        )
    }

    // MARK: - Civil day arithmetic

    /// A DST day is 23 or 25 hours long. Day comparisons therefore cannot be done by
    /// dividing seconds by 86,400 — this is the check that they are not.
    func testCivilDayAdvancesByOneAcrossATwentyThreeHourDay() {
        let chicago = zone("America/Chicago")
        let midnightMarch8 = utc(2026, 3, 8, 6) // 00:00 CST
        let midnightMarch9 = utc(2026, 3, 9, 5) // 00:00 CDT, only 23 hours later

        XCTAssertEqual(
            midnightMarch9.timeIntervalSince(midnightMarch8),
            23 * 3_600,
            "the calendar day really is 23 hours long"
        )

        let first = TimeZoneResolver.civilDayNumber(
            of: midnightMarch8, in: chicago, calendar: testCalendar
        )
        let second = TimeZoneResolver.civilDayNumber(
            of: midnightMarch9, in: chicago, calendar: testCalendar
        )
        XCTAssertEqual(second - first, 1)

        // Naively adding 86,400 seconds overshoots into 01:00 on the 9th.
        let naive = midnightMarch8.addingTimeInterval(86_400)
        XCTAssertEqual(wall(naive, "America/Chicago").hour, 1)
    }

    func testDayDeltaSpotsThatItIsAlreadyTomorrowSomewhere() {
        let chicago = zone("America/Chicago")
        let auckland = zone("Pacific/Auckland")
        let instant = utc(2026, 8, 6, 1) // Wed 5 Aug 20:00 in Chicago, Thu 6 Aug 13:00 in Auckland

        XCTAssertEqual(wall(instant, "America/Chicago").day, 5)
        XCTAssertEqual(wall(instant, "Pacific/Auckland").day, 6)
        XCTAssertEqual(
            TimeZoneResolver.dayDelta(
                of: instant, in: auckland, relativeTo: chicago, calendar: testCalendar
            ),
            1
        )
        XCTAssertEqual(
            TimeZoneResolver.dayDelta(
                of: instant, in: chicago, relativeTo: auckland, calendar: testCalendar
            ),
            -1
        )
        XCTAssertEqual(
            TimeZoneResolver.dayDelta(
                of: instant, in: chicago, relativeTo: chicago, calendar: testCalendar
            ),
            0
        )
    }

    func testUnknownIdentifierResolvesToNil() {
        XCTAssertNil(TimeZoneResolver.timeZone(forIdentifier: "Middle/Earth"))
        XCTAssertNotNil(TimeZoneResolver.timeZone(forIdentifier: "America/Chicago"))
    }
}
