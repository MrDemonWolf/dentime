import Foundation

/// Someone you have blocked, stored in your own private database.
///
/// Blocking in DenTime is client-side filtering. CloudKit runs no code of yours, so a
/// block cannot be enforced at the storage layer for public profile lookups. What backs
/// it up is friend-code rotation, which genuinely invalidates the old code, and removal
/// from a meetup's `CKShare`, which CloudKit does enforce.
///
/// **Copy rule, and it is not negotiable:** the UI says "You won't see them."
/// It never says "They can't see you." See docs/planning/DECISIONS.md, decision 6.
public struct Block: Equatable, Sendable, Codable, Identifiable {
    /// CloudKit record name in the user's private database. Nil until first save.
    public var recordName: String?
    /// The code that was blocked. Stored as the code rather than a record reference so a
    /// block survives the other person deleting and recreating their profile.
    public var blockedFriendCode: FriendCode
    /// When the block was created.
    public var createdAt: Date

    public var id: String { blockedFriendCode.rawValue }

    public init(
        recordName: String? = nil,
        blockedFriendCode: FriendCode,
        createdAt: Date
    ) {
        self.recordName = recordName
        self.blockedFriendCode = blockedFriendCode
        self.createdAt = createdAt
    }
}

extension Collection where Element == Block {
    /// True when this friend code has been blocked.
    public func blocks(_ friendCode: FriendCode) -> Bool {
        contains { $0.blockedFriendCode == friendCode }
    }
}
