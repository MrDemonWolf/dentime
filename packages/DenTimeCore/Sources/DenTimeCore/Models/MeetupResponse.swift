import Foundation

/// One participant's answer for one slot.
public enum RSVP: String, Equatable, Sendable, Codable, CaseIterable {
    case yes
    case no
    case maybe
}

/// A participant's RSVP against a single slot.
///
/// One row per participant per slot, so the host's results view is a straight tally and
/// changing your mind is an update rather than an append.
public struct MeetupResponse: Equatable, Sendable, Codable, Identifiable {
    /// CloudKit record name. Nil until first save.
    public var recordName: String?
    /// The slot being answered.
    public var slotRecordName: String?
    /// The participant's CloudKit record ID, as supplied by the share.
    public var participantRecordID: String
    /// Display name, denormalised so the host's results view renders in one pass.
    public var participantDisplayName: String
    /// Yes, no or maybe.
    public var response: RSVP
    /// When they answered.
    public var respondedAt: Date

    public var id: String {
        recordName ?? "\(slotRecordName ?? "-"):\(participantRecordID)"
    }

    public init(
        recordName: String? = nil,
        slotRecordName: String? = nil,
        participantRecordID: String,
        participantDisplayName: String,
        response: RSVP,
        respondedAt: Date
    ) {
        self.recordName = recordName
        self.slotRecordName = slotRecordName
        self.participantRecordID = participantRecordID
        self.participantDisplayName = participantDisplayName
        self.response = response
        self.respondedAt = respondedAt
    }
}
