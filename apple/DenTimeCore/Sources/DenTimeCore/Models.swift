import Foundation

public struct User: Codable, Identifiable, Equatable, Sendable {
    public let id: String
    public let displayName: String
    public let timezone: String
    public let friendCode: String
    public let subscriptionTier: String?

    public init(id: String, displayName: String, timezone: String, friendCode: String, subscriptionTier: String? = nil) {
        self.id = id
        self.displayName = displayName
        self.timezone = timezone
        self.friendCode = friendCode
        self.subscriptionTier = subscriptionTier
    }
}

public struct RosterEntry: Codable, Identifiable, Equatable, Sendable {
    public let id: String
    public let displayName: String
    public let timezone: String
    public let nickname: String?

    public init(id: String, displayName: String, timezone: String, nickname: String? = nil) {
        self.id = id
        self.displayName = displayName
        self.timezone = timezone
        self.nickname = nickname
    }

    public var displayLabel: String { nickname ?? displayName }
}

public struct Meetup: Codable, Identifiable, Equatable, Sendable {
    public let id: String
    public let ownerId: String
    public let title: String
    public let description: String?
    public let durationMinutes: Int
    public let status: String
    public let finalSlotId: String?
}

public struct MeetupSlot: Codable, Identifiable, Equatable, Sendable {
    public let id: String
    public let meetupId: String
    public let startUtc: Date
}
