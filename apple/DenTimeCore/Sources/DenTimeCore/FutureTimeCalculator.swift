import Foundation

public struct FuturePeek: Identifiable, Equatable, Sendable {
    public let id: String
    public let friend: RosterEntry
    public let instant: Date
    public let offsetHours: Double

    public var offsetLabel: String {
        if offsetHours == 0 { return "same" }
        let sign = offsetHours > 0 ? "+" : ""
        let whole = Int(offsetHours)
        if Double(whole) == offsetHours { return "\(sign)\(whole)h" }
        return String(format: "%@%.1fh", sign, offsetHours)
    }
}

public enum FutureTimeCalculator {
    public static func peek(
        yourInstant: Date,
        yourTimezone: TimeZone,
        roster: [RosterEntry]
    ) -> [FuturePeek] {
        roster.map { friend in
            let theirTz = TimeZone(identifier: friend.timezone) ?? .gmt
            let diffSeconds =
                theirTz.secondsFromGMT(for: yourInstant)
                - yourTimezone.secondsFromGMT(for: yourInstant)
            let offsetHours = Double(diffSeconds) / 3600.0
            return FuturePeek(
                id: friend.id,
                friend: friend,
                instant: yourInstant,
                offsetHours: offsetHours
            )
        }
    }
}
