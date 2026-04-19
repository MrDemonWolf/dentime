import Foundation
import Combine

@MainActor
final class FriendStore: ObservableObject {
    @Published private(set) var friends: [Friend] = []

    private let defaults: UserDefaults
    private let key = "dentime.friends.v1"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        load()
    }

    // MARK: - CRUD

    func add(_ friend: Friend) {
        var f = friend
        f.sortOrder = (friends.map(\.sortOrder).max() ?? -1) + 1
        friends.append(f)
        persist()
    }

    func update(_ friend: Friend) {
        guard let idx = friends.firstIndex(where: { $0.id == friend.id }) else { return }
        friends[idx] = friend
        persist()
    }

    func delete(id: UUID) {
        friends.removeAll { $0.id == id }
        persist()
    }

    func move(from source: IndexSet, to destination: Int) {
        friends.move(fromOffsets: source, toOffset: destination)
        // Re-index sortOrder to match current array order.
        for (i, _) in friends.enumerated() {
            friends[i].sortOrder = i
        }
        persist()
    }

    // MARK: - Groups

    /// Distinct non-nil group names, sorted alphabetically.
    var knownGroups: [String] {
        let set = Set(friends.compactMap { $0.groupName })
        return Array(set).sorted()
    }

    /// Friends grouped by groupName. "Friends" bucket (nil groupName) last.
    var groupedFriends: [(group: String, friends: [Friend])] {
        let grouped = Dictionary(grouping: friends) { $0.groupName ?? "" }
        var result: [(String, [Friend])] = []
        let namedKeys = grouped.keys.filter { !$0.isEmpty }.sorted()
        for key in namedKeys {
            let members = (grouped[key] ?? []).sorted { $0.sortOrder < $1.sortOrder }
            result.append((key, members))
        }
        if let ungrouped = grouped[""], !ungrouped.isEmpty {
            result.append(("Friends", ungrouped.sorted { $0.sortOrder < $1.sortOrder }))
        }
        return result
    }

    // MARK: - Persistence

    private func persist() {
        do {
            let data = try JSONEncoder().encode(friends)
            defaults.set(data, forKey: key)
        } catch {
            assertionFailure("FriendStore persist failed: \(error)")
        }
    }

    private func load() {
        guard let data = defaults.data(forKey: key) else { return }
        do {
            friends = try JSONDecoder().decode([Friend].self, from: data)
        } catch {
            friends = []
        }
    }
}
