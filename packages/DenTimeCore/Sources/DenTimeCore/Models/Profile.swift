import Foundation

/// The only record type in the public CloudKit database.
///
/// This struct is the entire public blast radius of DenTime: a display name, a friend
/// code, an IANA time zone identifier and an emoji. No email, no location finer than a
/// zone, no history. Nothing else about a user is ever resolvable by a stranger holding
/// a code. See docs/planning/CLOUDKIT-SCHEMA.md.
public struct Profile: Equatable, Sendable, Codable, Identifiable {
    /// CloudKit record name. Nil until the record has been saved for the first time.
    public var recordName: String?
    /// The shareable code. Queryable and indexed in CloudKit — the one index that matters.
    public var friendCode: FriendCode
    /// User-written. The only free text anywhere in DenTime.
    public var displayName: String
    /// IANA identifier, e.g. `America/Chicago`.
    public var timeZoneIdentifier: String
    /// A single emoji standing in for an avatar. No image uploads, so no image moderation.
    public var avatarEmoji: String

    public var id: String { friendCode.rawValue }

    /// The resolved zone, or nil when the stored identifier is not one this OS knows.
    public var timeZone: TimeZone? {
        TimeZoneResolver.timeZone(forIdentifier: timeZoneIdentifier)
    }

    public init(
        recordName: String? = nil,
        friendCode: FriendCode,
        displayName: String,
        timeZoneIdentifier: String,
        avatarEmoji: String
    ) {
        self.recordName = recordName
        self.friendCode = friendCode
        self.displayName = displayName
        self.timeZoneIdentifier = timeZoneIdentifier
        self.avatarEmoji = avatarEmoji
    }
}
