import Foundation

/// The code someone shares so you can add them to your den.
///
/// Eight Crockford base32 symbols, generated on device — no server allocates them.
/// Displayed as `DEN·XXXX-XXXX`; stored and queried as the bare eight symbols in
/// the public `UserProfile.friendCode` field.
///
/// Rotating a friend code genuinely invalidates the old one. That is what gives the
/// Block feature real teeth, since CloudKit cannot enforce a block at the storage
/// layer for public profile lookups. See docs/planning/DECISIONS.md, decision 6.
public struct FriendCode: PrefixedCode {
    public static let prefix = "DEN"

    public let rawValue: String

    public init(unchecked rawValue: String) {
        self.rawValue = rawValue
    }

    public init(from decoder: Decoder) throws {
        try self.init(decodingFrom: decoder)
    }

    public func encode(to encoder: Encoder) throws {
        try encodeRawValue(to: encoder)
    }
}
