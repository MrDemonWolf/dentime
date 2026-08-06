import Foundation

/// Where a meetup is in its life.
public enum MeetupStatus: String, Equatable, Sendable, Codable, CaseIterable {
    /// Open for RSVPs.
    case open
    /// Host stopped accepting new joins; existing participants can still see it.
    case closed
    /// Host picked a slot.
    case settled
}

/// A Doodle-style poll over a handful of times, shared with a `CKShare`.
///
/// **There is no title and no description field, and there never will be.** That single
/// omission makes display names the only user-written text in the app, which collapses
/// moderation from a report queue with a 24-hour SLA down to a Block button. It renders
/// in the UI as "[Host name]'s meetup" plus its date range. See
/// docs/planning/DECISIONS.md, decision 5.
public struct Meetup: Equatable, Sendable, Codable, Identifiable {
    /// CloudKit record name — the root record of the meetup's share. Nil until first save.
    public var recordName: String?
    /// When the host created it.
    public var createdAt: Date
    /// Open, closed or settled.
    public var status: MeetupStatus
    /// The code the host pastes into Discord or a group chat. Rotatable, disableable.
    public var joinCode: JoinCode
    /// Display name of the host, denormalised so a participant's list renders without
    /// a second lookup per row.
    public var hostDisplayName: String

    public var id: String { recordName ?? joinCode.rawValue }

    public init(
        recordName: String? = nil,
        createdAt: Date,
        status: MeetupStatus = .open,
        joinCode: JoinCode,
        hostDisplayName: String
    ) {
        self.recordName = recordName
        self.createdAt = createdAt
        self.status = status
        self.joinCode = joinCode
        self.hostDisplayName = hostDisplayName
    }
}
