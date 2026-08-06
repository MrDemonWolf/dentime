import Foundation

/// One person's row in the Den, rendered for a particular instant.
///
/// Every row carries a day-of-week and a `dayDelta`, because the whole point of the Den
/// is that you can see it is already tomorrow for someone before you propose a time.
public struct TimePeekRow: Equatable, Sendable, Identifiable {
    /// IANA identifier, e.g. `Europe/London`. Doubles as the row identity.
    public let timeZoneIdentifier: String
    /// The instant this row was rendered for — the same instant across every row.
    public let instant: Date
    /// Local hour, 0–23.
    public let hour: Int
    /// Local minute, 0–59.
    public let minute: Int
    /// Calendar weekday, 1 = Sunday in the Gregorian calendar.
    public let weekday: Int
    /// Short weekday name from the supplied calendar, e.g. `Wed`.
    public let weekdaySymbol: String
    /// Calendar days ahead of or behind the reference zone: -1, 0 or +1 in practice.
    public let dayDelta: Int
    /// Offset from UTC for display, e.g. `UTC+5:45`.
    public let offsetLabel: String
    /// Offset from the reference zone in minutes, e.g. -360.
    public let relativeOffsetMinutes: Int
    /// Zone abbreviation where one exists, e.g. `CST`.
    public let abbreviation: String
    /// True during the local night window — the mockup dims these rows and marks them ☾.
    public let isNight: Bool
    /// Preformatted local time honouring the user's 12/24-hour setting.
    public let formattedTime: String

    public var id: String { timeZoneIdentifier }
}

/// Client-side time scrubbing. Drag the scrubber, every row re-renders — no network call,
/// no CloudKit read, nothing leaves the device.
public enum TimePeek {
    /// How far the scrubber travels either side of now: twelve hours.
    public static let scrubRangeMinutes: ClosedRange<Int> = -720 ... 720

    /// Local hour at which the night window opens (inclusive).
    public static let nightStartHour = 22
    /// Local hour at which the night window closes (exclusive).
    public static let nightEndHour = 7

    /// Move an instant by a signed number of minutes, clamped to the scrubber's range.
    public static func scrubbedInstant(from base: Date, offsetMinutes: Int) -> Date {
        let clamped = min(max(offsetMinutes, scrubRangeMinutes.lowerBound), scrubRangeMinutes.upperBound)
        return base.addingTimeInterval(TimeInterval(clamped * 60))
    }

    /// True when `hour` falls in the local night window, which wraps past midnight.
    public static func isNightHour(_ hour: Int) -> Bool {
        hour >= nightStartHour || hour < nightEndHour
    }

    /// Render one row.
    public static func row(
        for zone: TimeZone,
        at instant: Date,
        relativeTo reference: TimeZone,
        format: TimeFormat = .twelveHour,
        calendar: Calendar = .gregorian
    ) -> TimePeekRow {
        let components = TimeZoneResolver.wallComponents(of: instant, in: zone, calendar: calendar)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let weekday = components.weekday ?? 1

        var zoned = calendar
        zoned.timeZone = zone
        let symbols = zoned.shortWeekdaySymbols
        let symbolIndex = weekday - 1
        let weekdaySymbol = symbols.indices.contains(symbolIndex) ? symbols[symbolIndex] : ""

        return TimePeekRow(
            timeZoneIdentifier: zone.identifier,
            instant: instant,
            hour: hour,
            minute: minute,
            weekday: weekday,
            weekdaySymbol: weekdaySymbol,
            dayDelta: TimeZoneResolver.dayDelta(
                of: instant,
                in: zone,
                relativeTo: reference,
                calendar: calendar
            ),
            offsetLabel: TimeZoneResolver.offsetLabel(for: zone, at: instant),
            relativeOffsetMinutes: TimeZoneResolver.offsetMinutes(
                for: zone,
                relativeTo: reference,
                at: instant
            ),
            abbreviation: TimeZoneResolver.abbreviation(for: zone, at: instant),
            isNight: isNightHour(hour),
            formattedTime: format.string(hour: hour, minute: minute)
        )
    }

    /// Render every row for the same instant. Order is preserved; the caller decides sorting.
    public static func rows(
        for zones: [TimeZone],
        at instant: Date,
        relativeTo reference: TimeZone,
        format: TimeFormat = .twelveHour,
        calendar: Calendar = .gregorian
    ) -> [TimePeekRow] {
        zones.map {
            row(for: $0, at: instant, relativeTo: reference, format: format, calendar: calendar)
        }
    }
}
