import Foundation
import XCTest

@testable import DenTimeCore

/// A deterministic generator so code-generation tests are reproducible.
/// Linear congruential — fine for tests, never used in production.
struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        state = seed
    }

    mutating func next() -> UInt64 {
        state = state &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
        return state
    }
}

extension XCTestCase {
    /// A Gregorian calendar with a fixed locale, so weekday symbols do not depend on
    /// whichever machine happens to run the tests.
    var testCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar
    }

    /// Build an instant from UTC wall-clock parts.
    func utc(
        _ year: Int,
        _ month: Int,
        _ day: Int,
        _ hour: Int = 0,
        _ minute: Int = 0,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        guard let date = calendar.date(from: components) else {
            XCTFail("could not build UTC date", file: file, line: line)
            return Date(timeIntervalSince1970: 0)
        }
        return date
    }

    /// Look up a zone, failing the test rather than crashing if the OS does not have it.
    func zone(
        _ identifier: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> TimeZone {
        guard let zone = TimeZone(identifier: identifier) else {
            XCTFail("unknown time zone \(identifier)", file: file, line: line)
            return TimeZone(secondsFromGMT: 0)!
        }
        return zone
    }

    /// Wall-clock components for an instant in a named zone.
    func wall(
        _ instant: Date,
        _ identifier: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> DateComponents {
        TimeZoneResolver.wallComponents(
            of: instant,
            in: zone(identifier, file: file, line: line),
            calendar: testCalendar
        )
    }

    /// Local wall-clock components for a zone, used when probing for nonexistent or
    /// repeated times.
    func localComponents(
        _ year: Int,
        _ month: Int,
        _ day: Int,
        _ hour: Int,
        _ minute: Int
    ) -> DateComponents {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        return components
    }
}
