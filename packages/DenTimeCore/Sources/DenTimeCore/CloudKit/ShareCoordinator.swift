import Foundation

#if canImport(CloudKit)
    import CloudKit
#endif

/// Creates and manages the `CKShare` behind each meetup.
///
/// Two things this deliberately does not do: send an invitation, and produce a rich link
/// preview. Meetups are join-by-code, never invite-by-push, because a push invite is a
/// channel a stranger holding your friend code could aim at you. Removing it removed the
/// abuse vector, a notification system and an invite state machine all at once.
///
/// A share link opened by someone without the app shows a generic "Get DenTime" page.
/// The good version needs CloudKit Web Services and is deferred — see
/// docs/planning/OPEN-QUESTIONS.md.
public protocol ShareCoordinating: Sendable {
    /// Create the share for a meetup and return its join URL.
    func createShare(for meetup: Meetup) async throws -> URL
    /// Accept a share the user opened or joined by code.
    func acceptShare(at url: URL) async throws -> Meetup
    /// Stop participating in a share you do not own.
    func removeSelf(from meetup: Meetup) async throws
    /// Remove someone else from a share you own. **This is enforced by CloudKit** — unlike
    /// blocking, which is client-side filtering.
    func removeParticipant(recordID: String, from meetup: Meetup) async throws
    /// Delete every share the user owns. The third part of account deletion, alongside the
    /// public profile and the private zone.
    func deleteAllOwnedShares() async throws
}

/// CloudKit-backed implementation. Phase 9.
public struct ShareCoordinator: ShareCoordinating {
    public init() {}

    public func createShare(for meetup: Meetup) async throws -> URL {
        fatalError("unimplemented")
    }

    public func acceptShare(at url: URL) async throws -> Meetup {
        fatalError("unimplemented")
    }

    public func removeSelf(from meetup: Meetup) async throws {
        fatalError("unimplemented")
    }

    public func removeParticipant(recordID: String, from meetup: Meetup) async throws {
        fatalError("unimplemented")
    }

    public func deleteAllOwnedShares() async throws {
        fatalError("unimplemented")
    }
}

/// Erases a DenTime account completely.
///
/// Apple auto-rejects apps without working in-app account deletion — guideline 5.1.1(v).
/// All three steps must succeed: public profile, private zone, owned shares.
public protocol AccountDeleting: Sendable {
    /// Purge everything, everywhere.
    func deleteAccount() async throws
}
