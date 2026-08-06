import Foundation

/// The user's own den: packs, roster entries, blocks and settings, all private.
///
/// Nothing in here is visible to anyone else, ever. Adding someone is one-way — it does
/// not add you to their den. See docs/planning/DECISIONS.md, decision 7.
public protocol RosterStoring: Sendable {
    /// Every pack, in sort order.
    func fetchPacks() async throws -> [Pack]
    /// Create or update a pack.
    func save(_ pack: Pack) async throws -> Pack
    /// Delete a pack. Entries in it become ungrouped rather than being deleted.
    func delete(pack: Pack) async throws

    /// Every roster entry, in sort order.
    func fetchEntries() async throws -> [RosterEntry]
    /// Create or update an entry.
    func save(_ entry: RosterEntry) async throws -> RosterEntry
    /// Remove someone from the den.
    func delete(entry: RosterEntry) async throws
    /// Reorder entries, and optionally move them between packs.
    func reorder(_ entries: [RosterEntry]) async throws

    /// Every block.
    func fetchBlocks() async throws -> [Block]
    /// Block a friend code. Filters them out of the den and out of meetup participant lists.
    func block(friendCode: FriendCode) async throws -> Block
    /// Unblock, from Settings › Blocked.
    func unblock(_ block: Block) async throws

    /// The user's settings record, or defaults if none has been saved.
    func fetchSettings() async throws -> Settings
    /// Persist settings.
    func save(_ settings: Settings) async throws -> Settings

    /// Purge the entire private zone. One half of account deletion; the other halves are
    /// the public profile and every share the user owns.
    func deleteAllPrivateData() async throws
}

/// CloudKit-backed implementation. Phase 6.
public struct RosterStore: RosterStoring {
    public init() {}

    public func fetchPacks() async throws -> [Pack] { fatalError("unimplemented") }
    public func save(_ pack: Pack) async throws -> Pack { fatalError("unimplemented") }
    public func delete(pack: Pack) async throws { fatalError("unimplemented") }

    public func fetchEntries() async throws -> [RosterEntry] { fatalError("unimplemented") }
    public func save(_ entry: RosterEntry) async throws -> RosterEntry { fatalError("unimplemented") }
    public func delete(entry: RosterEntry) async throws { fatalError("unimplemented") }
    public func reorder(_ entries: [RosterEntry]) async throws { fatalError("unimplemented") }

    public func fetchBlocks() async throws -> [Block] { fatalError("unimplemented") }
    public func block(friendCode: FriendCode) async throws -> Block { fatalError("unimplemented") }
    public func unblock(_ block: Block) async throws { fatalError("unimplemented") }

    public func fetchSettings() async throws -> Settings { fatalError("unimplemented") }
    public func save(_ settings: Settings) async throws -> Settings { fatalError("unimplemented") }

    public func deleteAllPrivateData() async throws { fatalError("unimplemented") }
}
