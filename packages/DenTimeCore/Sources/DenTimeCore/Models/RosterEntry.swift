import Foundation

/// One row in the Den.
///
/// CloudKit has no check constraints, so the "either a linked profile or a manual name
/// and zone, never both, never neither" rule from docs/planning/CLOUDKIT-SCHEMA.md is
/// enforced here instead — by making the two cases an enum rather than four optional
/// fields that could all be nil at once.
public enum RosterEntryKind: Equatable, Sendable, Codable {
    /// A real DenTime user, added by friend code. Their name and zone come from their
    /// public `Profile`, so the row updates when they travel.
    case linked(friendCode: FriendCode, profileRecordName: String?)
    /// Someone who does not use DenTime. Their name and zone are typed in and stay put.
    case manual(name: String, timeZoneIdentifier: String)
}

/// A person in your den, in a pack or loose at the top level.
public struct RosterEntry: Equatable, Sendable, Codable, Identifiable {
    /// CloudKit record name in the user's private database. Nil until first save.
    public var recordName: String?
    /// Which pack this row sits in, or nil for ungrouped.
    public var packRecordName: String?
    /// Manual ordering within its pack.
    public var sortOrder: Int
    /// Linked or manual — see `RosterEntryKind`.
    public var kind: RosterEntryKind

    public var id: String {
        if let recordName { return recordName }
        switch kind {
        case let .linked(friendCode, _): return "linked:\(friendCode.rawValue)"
        case let .manual(name, zone): return "manual:\(name):\(zone)"
        }
    }

    /// The friend code, for linked rows only. Manual rows have none.
    public var friendCode: FriendCode? {
        if case let .linked(friendCode, _) = kind { return friendCode }
        return nil
    }

    /// The name to show when no live `Profile` has been resolved yet.
    ///
    /// Linked rows fall back to their formatted friend code so a row is never blank
    /// while the public profile is still loading.
    public var fallbackDisplayName: String {
        switch kind {
        case let .linked(friendCode, _): return friendCode.formatted
        case let .manual(name, _): return name
        }
    }

    /// The zone for a manual row. Linked rows resolve theirs from the live `Profile`.
    public var manualTimeZone: TimeZone? {
        guard case let .manual(_, identifier) = kind else { return nil }
        return TimeZoneResolver.timeZone(forIdentifier: identifier)
    }

    public init(
        recordName: String? = nil,
        packRecordName: String? = nil,
        sortOrder: Int = 0,
        kind: RosterEntryKind
    ) {
        self.recordName = recordName
        self.packRecordName = packRecordName
        self.sortOrder = sortOrder
        self.kind = kind
    }
}
