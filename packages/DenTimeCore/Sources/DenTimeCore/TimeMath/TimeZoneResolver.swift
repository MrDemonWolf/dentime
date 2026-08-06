import Foundation

/// Pure time-zone arithmetic. No network, no CloudKit, no reads of `TimeZone.current`
/// from inside a function — every input is injected so tests are deterministic.
///
/// The failure mode this file exists to prevent is someone showing up on the wrong day.
/// Every day comparison here is done on civil calendar dates, never on 24-hour arithmetic,
/// because a DST day is 23 or 25 hours long.
public enum TimeZoneResolver {
    /// A time zone for an IANA identifier such as `America/Chicago`, or nil if unknown.
    public static func timeZone(forIdentifier identifier: String) -> TimeZone? {
        TimeZone(identifier: identifier)
    }

    /// Seconds east of UTC at a given instant, DST included.
    public static func offsetSeconds(for zone: TimeZone, at instant: Date) -> Int {
        zone.secondsFromGMT(for: instant)
    }

    /// Minutes this zone runs ahead of (positive) or behind (negative) `reference`.
    ///
    /// Computed at a specific instant because two zones do not change their offsets on
    /// the same date — Europe and North America shift weeks apart.
    public static func offsetMinutes(
        for zone: TimeZone,
        relativeTo reference: TimeZone,
        at instant: Date
    ) -> Int {
        (offsetSeconds(for: zone, at: instant) - offsetSeconds(for: reference, at: instant)) / 60
    }

    /// Offset rendered for display: `UTC`, `UTC+2`, `UTC−5:30`, `UTC+5:45`.
    ///
    /// Uses a real minus sign, not a hyphen, to match the mockup's typography.
    public static func offsetLabel(for zone: TimeZone, at instant: Date) -> String {
        let totalMinutes = offsetSeconds(for: zone, at: instant) / 60
        if totalMinutes == 0 { return "UTC" }
        let sign = totalMinutes < 0 ? "\u{2212}" : "+"
        let magnitude = abs(totalMinutes)
        let hours = magnitude / 60
        let minutes = magnitude % 60
        return minutes == 0
            ? "UTC\(sign)\(hours)"
            : String(format: "UTC%@%d:%02d", sign, hours, minutes)
    }

    /// Short zone abbreviation such as `CST`, falling back to the offset label when the
    /// platform has none — plenty of zones have no meaningful abbreviation.
    public static func abbreviation(for zone: TimeZone, at instant: Date) -> String {
        zone.abbreviation(for: instant) ?? offsetLabel(for: zone, at: instant)
    }

    /// True when daylight saving is in effect in `zone` at `instant`.
    public static func isDaylightSavingTime(for zone: TimeZone, at instant: Date) -> Bool {
        zone.isDaylightSavingTime(for: instant)
    }

    /// The next moment `zone` changes its UTC offset, if there is one.
    public static func nextTransition(for zone: TimeZone, after instant: Date) -> Date? {
        zone.nextDaylightSavingTimeTransition(after: instant)
    }

    // MARK: - Civil dates

    /// Wall-clock components in `zone` for a given instant. Always well defined.
    public static func wallComponents(
        of instant: Date,
        in zone: TimeZone,
        calendar: Calendar = .gregorian
    ) -> DateComponents {
        var zoned = calendar
        zoned.timeZone = zone
        return zoned.dateComponents([.year, .month, .day, .hour, .minute, .weekday], from: instant)
    }

    /// A stable integer for the civil date (year/month/day) seen in `zone` at `instant`.
    ///
    /// The date is re-anchored to noon UTC before being turned into a day count, so a
    /// 23- or 25-hour DST day can never round it to the wrong side of midnight.
    public static func civilDayNumber(
        of instant: Date,
        in zone: TimeZone,
        calendar: Calendar = .gregorian
    ) -> Int {
        let components = wallComponents(of: instant, in: zone, calendar: calendar)
        var anchored = DateComponents()
        anchored.year = components.year
        anchored.month = components.month
        anchored.day = components.day
        anchored.hour = 12
        guard let noonUTC = Calendar.utcGregorian.date(from: anchored) else { return 0 }
        return Int((noonUTC.timeIntervalSince1970 / 86_400).rounded(.down))
    }

    /// How many calendar days ahead (positive) or behind (negative) `zone` is of
    /// `reference` at the same instant. This is the "wrong day" guard.
    public static func dayDelta(
        of instant: Date,
        in zone: TimeZone,
        relativeTo reference: TimeZone,
        calendar: Calendar = .gregorian
    ) -> Int {
        civilDayNumber(of: instant, in: zone, calendar: calendar)
            - civilDayNumber(of: instant, in: reference, calendar: calendar)
    }

    // MARK: - Wall times that do not exist, or exist twice

    /// The instant at which a wall-clock time occurs in `zone`, if it occurs at all.
    ///
    /// On a spring-forward morning the clock jumps from 01:59 to 03:00, so 02:30 never
    /// happens. Foundation quietly returns the shifted instant instead of failing, which
    /// is why `wallTimeExists` is the check callers actually want.
    public static func instant(
        forWallTime components: DateComponents,
        in zone: TimeZone,
        calendar: Calendar = .gregorian
    ) -> Date? {
        var zoned = calendar
        zoned.timeZone = zone
        var normalized = components
        normalized.timeZone = zone
        return zoned.date(from: normalized)
    }

    /// False when the given wall-clock time is skipped by a spring-forward transition.
    public static func wallTimeExists(
        _ components: DateComponents,
        in zone: TimeZone,
        calendar: Calendar = .gregorian
    ) -> Bool {
        guard let candidate = instant(forWallTime: components, in: zone, calendar: calendar) else {
            return false
        }
        let rendered = wallComponents(of: candidate, in: zone, calendar: calendar)
        return rendered.hour == components.hour && rendered.minute == (components.minute ?? 0)
    }

    /// True when the given wall-clock time happens twice because clocks moved backwards.
    ///
    /// Checked against several shift sizes: most zones move a full hour, Lord Howe moves
    /// thirty minutes, and a couple of historical zones moved two.
    public static func wallTimeIsAmbiguous(
        _ components: DateComponents,
        in zone: TimeZone,
        calendar: Calendar = .gregorian
    ) -> Bool {
        guard let first = instant(forWallTime: components, in: zone, calendar: calendar) else {
            return false
        }
        for shiftSeconds in [1_800, 3_600, 7_200] {
            let later = first.addingTimeInterval(TimeInterval(shiftSeconds))
            let rendered = wallComponents(of: later, in: zone, calendar: calendar)
            if rendered.hour == components.hour,
               rendered.minute == (components.minute ?? 0),
               rendered.day == components.day
            {
                return true
            }
        }
        return false
    }
}

extension Calendar {
    /// A Gregorian calendar with no zone applied yet — callers set `timeZone` themselves.
    public static var gregorian: Calendar {
        Calendar(identifier: .gregorian)
    }

    /// A fixed UTC Gregorian calendar, used as a DST-free ruler for day arithmetic.
    static var utcGregorian: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .gmt
        return calendar
    }
}
