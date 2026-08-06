import Foundation

/// User preferences, synced through the private database.
///
/// Small enough to be a single record. Everything here is a display choice — nothing in
/// this struct changes what the app can do, because there are no tiers and no unlocks.
public struct Settings: Equatable, Sendable, Codable {
    /// CloudKit record name. Nil until first save.
    public var recordName: String?
    /// Den or Team nouns. Swaps seven words, never the voice.
    public var vocabulary: Vocabulary
    /// 12- or 24-hour clock.
    public var timeFormat: TimeFormat
    /// Whether DenTime starts with the Mac.
    public var launchAtLogin: Bool

    public static let `default` = Settings(
        vocabulary: .den,
        timeFormat: .twelveHour,
        launchAtLogin: false
    )

    public init(
        recordName: String? = nil,
        vocabulary: Vocabulary = .den,
        timeFormat: TimeFormat = .twelveHour,
        launchAtLogin: Bool = false
    ) {
        self.recordName = recordName
        self.vocabulary = vocabulary
        self.timeFormat = timeFormat
        self.launchAtLogin = launchAtLogin
    }
}
