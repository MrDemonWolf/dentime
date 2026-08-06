import Foundation
import XCTest

@testable import DenTimeCore

final class ModelTests: XCTestCase {
    // MARK: - Roster entries

    /// CloudKit has no check constraints, so "linked or manual, never both, never neither"
    /// is enforced by the shape of the type rather than by a runtime guard.
    func testRosterEntryIsEitherLinkedOrManual() {
        let code = FriendCode(unchecked: "ABCD2345")
        let linked = RosterEntry(kind: .linked(friendCode: code, profileRecordName: nil))
        let manual = RosterEntry(
            kind: .manual(name: "Kaya", timeZoneIdentifier: "Europe/London")
        )

        XCTAssertEqual(linked.friendCode, code)
        XCTAssertNil(linked.manualTimeZone)
        XCTAssertEqual(linked.fallbackDisplayName, code.formatted)

        XCTAssertNil(manual.friendCode)
        XCTAssertEqual(manual.manualTimeZone?.identifier, "Europe/London")
        XCTAssertEqual(manual.fallbackDisplayName, "Kaya")
    }

    func testRosterEntryRoundTripsThroughCodable() throws {
        let entry = RosterEntry(
            recordName: "rec-1",
            packRecordName: "pack-1",
            sortOrder: 3,
            kind: .linked(friendCode: FriendCode(unchecked: "ABCD2345"), profileRecordName: "p-1")
        )
        let data = try JSONEncoder().encode(entry)
        XCTAssertEqual(try JSONDecoder().decode(RosterEntry.self, from: data), entry)
    }

    // MARK: - Blocking

    func testBlockLookupMatchesOnCode() {
        let blocked = FriendCode(unchecked: "ABCD2345")
        let other = FriendCode(unchecked: "WXYZ6789")
        let blocks = [Block(blockedFriendCode: blocked, createdAt: Date(timeIntervalSince1970: 0))]

        XCTAssertTrue(blocks.blocks(blocked))
        XCTAssertFalse(blocks.blocks(other))
        XCTAssertFalse([Block]().blocks(blocked))
    }

    // MARK: - Vocabulary

    func testVocabularySwapsExactlySevenNouns() {
        let den = Vocabulary.den.terms
        let team = Vocabulary.team.terms

        XCTAssertEqual(den.collection, "Den")
        XCTAssertEqual(den.group, "Pack")
        XCTAssertEqual(den.host, "Host")
        XCTAssertEqual(den.gathering, "Meetup")
        XCTAssertEqual(den.code, "Friend code")
        XCTAssertEqual(den.attending, "Who's in")
        XCTAssertEqual(den.planVerb, "Make a plan")

        XCTAssertEqual(team.collection, "Team")
        XCTAssertEqual(team.group, "Group")
        XCTAssertEqual(team.host, "Organizer")
        XCTAssertEqual(team.gathering, "Meeting")
        XCTAssertEqual(team.code, "Member code")
        XCTAssertEqual(team.attending, "Attending")
        XCTAssertEqual(team.planVerb, "Schedule")

        // Every one of the seven differs between modes — none is decorative.
        XCTAssertNotEqual(den.collection, team.collection)
        XCTAssertNotEqual(den.group, team.group)
        XCTAssertNotEqual(den.host, team.host)
        XCTAssertNotEqual(den.gathering, team.gathering)
        XCTAssertNotEqual(den.code, team.code)
        XCTAssertNotEqual(den.attending, team.attending)
        XCTAssertNotEqual(den.planVerb, team.planVerb)
    }

    func testDenIsTheDefaultVocabulary() {
        XCTAssertEqual(Settings.default.vocabulary, .den)
        XCTAssertEqual(Settings.default.timeFormat, .twelveHour)
        XCTAssertFalse(Settings.default.launchAtLogin)
    }

    // MARK: - Meetup validation

    func testMeetupAcceptsTwoToFiveSlots() throws {
        let store = MeetupStore()
        for count in MeetupSlot.minimumSlotsPerMeetup ... MeetupSlot.maximumSlotsPerMeetup {
            XCTAssertNoThrow(try store.validate(slots: slots(count: count)))
        }
    }

    func testMeetupRejectsTooFewOrTooManySlots() {
        let store = MeetupStore()
        XCTAssertThrowsError(try store.validate(slots: slots(count: 1))) { error in
            XCTAssertEqual(error as? MeetupValidationError, .slotCountOutOfRange(count: 1))
        }
        XCTAssertThrowsError(try store.validate(slots: slots(count: 6))) { error in
            XCTAssertEqual(error as? MeetupValidationError, .slotCountOutOfRange(count: 6))
        }
    }

    func testMeetupRejectsDuplicateStartsAndNonPositiveDurations() {
        let store = MeetupStore()
        let start = utc(2026, 8, 6, 1)

        let duplicated = [
            MeetupSlot(startsAtUTC: start, durationMinutes: 60),
            MeetupSlot(startsAtUTC: start, durationMinutes: 60),
        ]
        XCTAssertThrowsError(try store.validate(slots: duplicated)) { error in
            XCTAssertEqual(error as? MeetupValidationError, .duplicateSlotStart(start))
        }

        let zeroLength = [
            MeetupSlot(startsAtUTC: start, durationMinutes: 0),
            MeetupSlot(startsAtUTC: start.addingTimeInterval(3_600), durationMinutes: 60),
        ]
        XCTAssertThrowsError(try store.validate(slots: zeroLength)) { error in
            XCTAssertEqual(error as? MeetupValidationError, .nonPositiveDuration(minutes: 0))
        }
    }

    private func slots(count: Int) -> [MeetupSlot] {
        (0 ..< count).map {
            MeetupSlot(
                startsAtUTC: utc(2026, 8, 6, 1).addingTimeInterval(TimeInterval($0 * 3_600)),
                durationMinutes: 60
            )
        }
    }
}
