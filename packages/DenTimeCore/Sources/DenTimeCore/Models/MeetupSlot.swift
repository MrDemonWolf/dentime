import Foundation

/// One proposed time in a meetup. A host proposes between two and five of these.
///
/// The start is stored as a UTC instant, never as a wall-clock time plus a zone, so that
/// every participant renders the same moment in their own local time and nobody has to
/// reason about whose zone the number was written in.
public struct MeetupSlot: Equatable, Sendable, Codable, Identifiable {
    /// Minimum slots a host may propose.
    public static let minimumSlotsPerMeetup = 2
    /// Maximum slots a host may propose. More than this stops fitting the results view.
    public static let maximumSlotsPerMeetup = 5

    /// CloudKit record name. Nil until first save.
    public var recordName: String?
    /// The meetup this slot belongs to.
    public var meetupRecordName: String?
    /// The instant the slot starts, in UTC.
    public var startsAtUTC: Date
    /// How long it runs.
    public var durationMinutes: Int

    public var id: String { recordName ?? "\(startsAtUTC.timeIntervalSince1970)" }

    /// The instant the slot ends.
    public var endsAtUTC: Date {
        startsAtUTC.addingTimeInterval(TimeInterval(durationMinutes * 60))
    }

    /// This slot rendered for one participant's zone, including the day-of-week and the
    /// day delta that stop someone turning up on the wrong evening.
    public func peekRow(
        in zone: TimeZone,
        relativeTo reference: TimeZone,
        format: TimeFormat = .twelveHour,
        calendar: Calendar = .gregorian
    ) -> TimePeekRow {
        TimePeek.row(
            for: zone,
            at: startsAtUTC,
            relativeTo: reference,
            format: format,
            calendar: calendar
        )
    }

    public init(
        recordName: String? = nil,
        meetupRecordName: String? = nil,
        startsAtUTC: Date,
        durationMinutes: Int
    ) {
        self.recordName = recordName
        self.meetupRecordName = meetupRecordName
        self.startsAtUTC = startsAtUTC
        self.durationMinutes = durationMinutes
    }
}
