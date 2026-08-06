import Foundation

/// Meetups, their slots and their RSVPs.
///
/// A meetup lives in a `CKShare` owned by its host, not in the public database. The share
/// URL is the join link, and removing someone from a share is enforced by CloudKit at the
/// storage layer — the one place blocking genuinely bites.
public protocol MeetupStoring: Sendable {
    /// Meetups the user hosts.
    func fetchHostedMeetups() async throws -> [Meetup]
    /// Meetups the user has joined.
    func fetchJoinedMeetups() async throws -> [Meetup]

    /// Create a meetup with between two and five slots, returning it and its saved slots.
    ///
    /// Throws `MeetupValidationError.slotCountOutOfRange` outside that range.
    func createMeetup(slots: [MeetupSlot]) async throws -> (Meetup, [MeetupSlot])
    /// Join by code. Returns nil when no meetup matches or the code has been disabled.
    func join(code: JoinCode) async throws -> Meetup?
    /// Leave a meetup you joined.
    func leave(meetup: Meetup) async throws
    /// Close or settle a meetup you host.
    func update(meetup: Meetup, status: MeetupStatus) async throws -> Meetup
    /// Issue a new join code, invalidating the old one.
    func rotateJoinCode(for meetup: Meetup) async throws -> JoinCode

    /// Slots for a meetup, in chronological order.
    func fetchSlots(for meetup: Meetup) async throws -> [MeetupSlot]
    /// Every RSVP for a meetup — what the host's results view renders.
    func fetchResponses(for meetup: Meetup) async throws -> [MeetupResponse]
    /// Record or change the user's own RSVP for a slot.
    func respond(to slot: MeetupSlot, with response: RSVP) async throws -> MeetupResponse
}

/// What can go wrong before a meetup ever reaches CloudKit.
public enum MeetupValidationError: Error, Equatable, Sendable {
    /// Fewer than two or more than five slots were proposed.
    case slotCountOutOfRange(count: Int)
    /// Two slots start at the same instant.
    case duplicateSlotStart(Date)
    /// A slot's duration was zero or negative.
    case nonPositiveDuration(minutes: Int)
}

extension MeetupStoring {
    /// Local validation of a proposed slot set, run before any network call.
    public func validate(slots: [MeetupSlot]) throws {
        guard (MeetupSlot.minimumSlotsPerMeetup ... MeetupSlot.maximumSlotsPerMeetup)
            .contains(slots.count)
        else {
            throw MeetupValidationError.slotCountOutOfRange(count: slots.count)
        }
        for slot in slots where slot.durationMinutes <= 0 {
            throw MeetupValidationError.nonPositiveDuration(minutes: slot.durationMinutes)
        }
        var seen = Set<Date>()
        for slot in slots {
            guard seen.insert(slot.startsAtUTC).inserted else {
                throw MeetupValidationError.duplicateSlotStart(slot.startsAtUTC)
            }
        }
    }
}

/// CloudKit-backed implementation. Phase 9.
public struct MeetupStore: MeetupStoring {
    public init() {}

    public func fetchHostedMeetups() async throws -> [Meetup] { fatalError("unimplemented") }
    public func fetchJoinedMeetups() async throws -> [Meetup] { fatalError("unimplemented") }

    public func createMeetup(slots: [MeetupSlot]) async throws -> (Meetup, [MeetupSlot]) {
        fatalError("unimplemented")
    }

    public func join(code: JoinCode) async throws -> Meetup? { fatalError("unimplemented") }
    public func leave(meetup: Meetup) async throws { fatalError("unimplemented") }

    public func update(meetup: Meetup, status: MeetupStatus) async throws -> Meetup {
        fatalError("unimplemented")
    }

    public func rotateJoinCode(for meetup: Meetup) async throws -> JoinCode {
        fatalError("unimplemented")
    }

    public func fetchSlots(for meetup: Meetup) async throws -> [MeetupSlot] {
        fatalError("unimplemented")
    }

    public func fetchResponses(for meetup: Meetup) async throws -> [MeetupResponse] {
        fatalError("unimplemented")
    }

    public func respond(to slot: MeetupSlot, with response: RSVP) async throws -> MeetupResponse {
        fatalError("unimplemented")
    }
}
