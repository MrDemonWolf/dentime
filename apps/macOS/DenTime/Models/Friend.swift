import Foundation

struct Friend: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var timezoneIdentifier: String
    var groupName: String?
    var colorHex: String?
    var sortOrder: Int

    init(
        id: UUID = UUID(),
        name: String,
        timezoneIdentifier: String,
        groupName: String? = nil,
        colorHex: String? = nil,
        sortOrder: Int = 0
    ) {
        self.id = id
        self.name = name
        self.timezoneIdentifier = timezoneIdentifier
        self.groupName = groupName
        self.colorHex = colorHex
        self.sortOrder = sortOrder
    }

    var timezone: TimeZone {
        TimeZone(identifier: timezoneIdentifier) ?? .current
    }

    var city: String {
        let last = timezoneIdentifier.split(separator: "/").last.map(String.init) ?? timezoneIdentifier
        return last.replacingOccurrences(of: "_", with: " ")
    }

    /// Hours ahead (+) or behind (-) the given reference zone.
    func hourDelta(from reference: TimeZone = .current, at date: Date = Date()) -> Int {
        let selfOffset = timezone.secondsFromGMT(for: date)
        let refOffset = reference.secondsFromGMT(for: date)
        return (selfOffset - refOffset) / 3600
    }
}
