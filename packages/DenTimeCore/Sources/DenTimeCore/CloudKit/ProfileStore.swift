import Foundation

/// Reads and writes the one public record type.
///
/// `lookup(friendCode:)` is the only query DenTime ever runs against the public database,
/// and it is why `UserProfile.friendCode` must be marked queryable **and indexed** by hand
/// in the CloudKit dashboard. Without that index the lookup fails at runtime, not at build
/// time. See docs/planning/CLOUDKIT-SCHEMA.md.
public protocol ProfileStoring: Sendable {
    /// The signed-in user's own public profile, or nil if they have not published one yet.
    func fetchOwnProfile() async throws -> Profile?
    /// Create or update the signed-in user's public profile.
    func save(_ profile: Profile) async throws -> Profile
    /// Resolve a stranger's profile from a friend code. Returns nil when no profile matches.
    func lookup(friendCode: FriendCode) async throws -> Profile?
    /// Issue a new friend code, invalidating the old one.
    func rotateFriendCode() async throws -> FriendCode
    /// Delete the public profile. Part of, but not all of, account deletion.
    func deleteOwnProfile() async throws
}

/// CloudKit-backed implementation. Phase 5.
public struct ProfileStore: ProfileStoring {
    public init() {}

    public func fetchOwnProfile() async throws -> Profile? {
        fatalError("unimplemented")
    }

    public func save(_ profile: Profile) async throws -> Profile {
        fatalError("unimplemented")
    }

    public func lookup(friendCode: FriendCode) async throws -> Profile? {
        fatalError("unimplemented")
    }

    public func rotateFriendCode() async throws -> FriendCode {
        fatalError("unimplemented")
    }

    public func deleteOwnProfile() async throws {
        fatalError("unimplemented")
    }
}
