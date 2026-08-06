import Foundation

/// A collapsible group of people in the Den — "the boys", "raid night", "Acme Corp".
///
/// Packs are what let one design serve friend groups, teams and clients without any
/// screen being slightly wrong for everyone. A pack named for a company behaves exactly
/// like a pack named for a friend group. See docs/planning/DECISIONS.md, decision 8.
public struct Pack: Equatable, Sendable, Codable, Identifiable {
    /// CloudKit record name in the user's private database. Nil until first save.
    public var recordName: String?
    /// User-written label. Sample data reads "movie night", never "Q3 planning sync".
    public var name: String
    /// Manual ordering in the Den.
    public var sortOrder: Int
    /// Whether the group is folded up in the Den.
    public var isCollapsed: Bool

    public var id: String { recordName ?? name }

    public init(
        recordName: String? = nil,
        name: String,
        sortOrder: Int = 0,
        isCollapsed: Bool = false
    ) {
        self.recordName = recordName
        self.name = name
        self.sortOrder = sortOrder
        self.isCollapsed = isCollapsed
    }
}
