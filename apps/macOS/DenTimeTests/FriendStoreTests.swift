import XCTest
@testable import DenTime

@MainActor
final class FriendStoreTests: XCTestCase {
    var defaults: UserDefaults!
    var suiteName: String!

    override func setUp() {
        super.setUp()
        suiteName = "DenTimeTests.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        super.tearDown()
    }

    func testAddAndDelete() {
        let store = FriendStore(defaults: defaults)
        let alex = Friend(name: "Alex", timezoneIdentifier: "Europe/Berlin")
        store.add(alex)
        XCTAssertEqual(store.friends.count, 1)
        store.delete(id: alex.id)
        XCTAssertTrue(store.friends.isEmpty)
    }

    func testUpdate() {
        let store = FriendStore(defaults: defaults)
        let sam = Friend(name: "Sam", timezoneIdentifier: "Asia/Tokyo")
        store.add(sam)
        var edited = store.friends[0]
        edited.name = "Samantha"
        store.update(edited)
        XCTAssertEqual(store.friends[0].name, "Samantha")
    }

    func testPersistenceAcrossInstances() {
        let store1 = FriendStore(defaults: defaults)
        store1.add(Friend(name: "A", timezoneIdentifier: "UTC"))
        store1.add(Friend(name: "B", timezoneIdentifier: "UTC", groupName: "Work"))

        let store2 = FriendStore(defaults: defaults)
        XCTAssertEqual(store2.friends.count, 2)
    }

    func testGrouping() {
        let store = FriendStore(defaults: defaults)
        store.add(Friend(name: "A", timezoneIdentifier: "UTC", groupName: "Work"))
        store.add(Friend(name: "B", timezoneIdentifier: "UTC", groupName: "Pack"))
        store.add(Friend(name: "C", timezoneIdentifier: "UTC", groupName: nil))

        let grouped = store.groupedFriends
        XCTAssertEqual(grouped.map(\.group), ["Pack", "Work", "Friends"])
    }

    func testKnownGroups() {
        let store = FriendStore(defaults: defaults)
        store.add(Friend(name: "A", timezoneIdentifier: "UTC", groupName: "Work"))
        store.add(Friend(name: "B", timezoneIdentifier: "UTC", groupName: "Work"))
        store.add(Friend(name: "C", timezoneIdentifier: "UTC", groupName: "Pack"))
        XCTAssertEqual(store.knownGroups, ["Pack", "Work"])
    }
}
