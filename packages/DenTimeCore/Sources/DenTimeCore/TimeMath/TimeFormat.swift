import Foundation

/// How times are rendered throughout the app. Set once in Settings, applied everywhere.
public enum TimeFormat: String, Codable, Sendable, CaseIterable {
    case twelveHour
    case twentyFourHour

    /// Render an hour and minute without touching `DateFormatter`.
    ///
    /// Deliberately not locale-driven: these strings sit in a tabular monospaced column
    /// next to each other, and a locale that inserts a narrow no-break space or reorders
    /// the meridiem breaks the alignment. Vocabulary and locale change the nouns around
    /// the time, never the digits.
    public func string(hour: Int, minute: Int) -> String {
        switch self {
        case .twentyFourHour:
            return String(format: "%02d:%02d", hour, minute)
        case .twelveHour:
            let displayHour = hour % 12 == 0 ? 12 : hour % 12
            let meridiem = hour < 12 ? "AM" : "PM"
            return String(format: "%d:%02d %@", displayHour, minute, meridiem)
        }
    }
}
