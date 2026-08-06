import Foundation

/// The code a host pastes wherever their pack already talks, so people can join a meetup.
///
/// Same eight-symbol Crockford alphabet as `FriendCode`, different prefix: `HOWL·XXXX-XXXX`.
/// DenTime never sends this anywhere itself — meetups are join-by-code, never invite-by-push.
/// See docs/planning/DECISIONS.md, decision 4.
public struct JoinCode: PrefixedCode {
    public static let prefix = "HOWL"

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
