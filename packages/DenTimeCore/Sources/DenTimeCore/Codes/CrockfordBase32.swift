import Foundation

/// Crockford base32 alphabet and the character rules DenTime codes obey.
///
/// Note the deliberate deviation from canonical Crockford: the specification says a
/// *decoder* should treat `I` and `L` as `1` and `O` as `0`, rejecting only `U`.
/// DenTime rejects all four outright so that a code is either exactly right or clearly
/// wrong — there is no silently-corrected variant of someone's friend code floating
/// around. Recorded in docs/planning/OPEN-QUESTIONS.md.
public enum CrockfordBase32 {
    /// 32 symbols: digits plus letters, minus I, L, O and U.
    public static let alphabet = "0123456789ABCDEFGHJKMNPQRSTVWXYZ"

    /// Characters excluded because they are easy to misread as digits.
    public static let ambiguousCharacters: Set<Character> = ["I", "L", "O", "U"]

    static let alphabetCharacters = Array(alphabet)
    static let alphabetSet = Set(alphabet)

    /// True when `character` is a legal symbol. Case-sensitive: normalise first.
    public static func isValidSymbol(_ character: Character) -> Bool {
        alphabetSet.contains(character)
    }

    /// A random string of `length` symbols drawn uniformly from the alphabet.
    ///
    /// The generator is injected so tests can be deterministic. Production callers use
    /// `SystemRandomNumberGenerator`, which is cryptographically secure on Apple platforms.
    public static func randomString<G: RandomNumberGenerator>(
        length: Int,
        using generator: inout G
    ) -> String {
        precondition(length > 0, "code length must be positive")
        var result = ""
        result.reserveCapacity(length)
        for _ in 0 ..< length {
            let index = Int(generator.next(upperBound: UInt64(alphabetCharacters.count)))
            result.append(alphabetCharacters[index])
        }
        return result
    }
}

/// Why a string could not be read as a DenTime code.
public enum CodeParseError: Error, Equatable, Sendable {
    /// The code had the wrong number of symbols after separators were stripped.
    case wrongLength(expected: Int, actual: Int)
    /// The code contained I, L, O or U — excluded because they misread as digits.
    case ambiguousCharacter(Character)
    /// The code contained a character outside the Crockford alphabet.
    case invalidCharacter(Character)
    /// The code carried a prefix belonging to a different kind of code.
    case wrongPrefix(expected: String, actual: String)
}

/// Shared parsing and formatting for the prefixed 8-symbol codes DenTime hands out.
///
/// Conform, set a prefix, and get `init(parsing:)`, `formatted` and `isValid(_:)` for free.
public protocol PrefixedCode: Hashable, Sendable, Codable, CustomStringConvertible {
    /// Display prefix, without the separator — `"DEN"` or `"HOWL"`.
    static var prefix: String { get }
    /// Symbol count, excluding prefix and separators.
    static var length: Int { get }
    /// The bare symbols, uppercase, no prefix and no separators. This is what CloudKit stores.
    var rawValue: String { get }
    /// Construct without validating. Use `init(parsing:)` for anything user-supplied.
    init(unchecked rawValue: String)
}

extension PrefixedCode {
    public static var length: Int { 8 }

    /// Separator between the prefix and the symbols. A middle dot, matching the mockup.
    public static var prefixSeparator: Character { "\u{00B7}" }

    /// Characters a human might type or paste between symbols, all discarded on parse.
    static var strippableSeparators: Set<Character> {
        ["-", "\u{00B7}", " ", "\u{2013}", "\u{2014}", "_"]
    }

    /// Parse a user-supplied string: case-insensitive, prefix optional, separators optional.
    ///
    /// Accepts `DEN·ABCD-EFGH`, `den abcd efgh`, `ABCDEFGH` and similar. Rejects anything
    /// whose symbol count is wrong or that contains I, L, O or U.
    public init(parsing input: String) throws {
        var text = input.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        // Strip the prefix only when a separator follows it. Without that rule a legitimate
        // code that happens to start with the prefix letters would be silently truncated.
        let prefix = Self.prefix.uppercased()
        if text.count > prefix.count, text.hasPrefix(prefix) {
            let afterPrefix = text.index(text.startIndex, offsetBy: prefix.count)
            if Self.strippableSeparators.contains(text[afterPrefix]) {
                text = String(text[text.index(after: afterPrefix)...])
            }
        }

        // Reject a prefix belonging to a different code type before it looks like bad symbols.
        for other in ["DEN", "HOWL"] where other != prefix {
            if text.count > other.count, text.hasPrefix(other) {
                let afterOther = text.index(text.startIndex, offsetBy: other.count)
                if Self.strippableSeparators.contains(text[afterOther]) {
                    throw CodeParseError.wrongPrefix(expected: prefix, actual: other)
                }
            }
        }

        let symbols = text.filter { !Self.strippableSeparators.contains($0) }

        guard symbols.count == Self.length else {
            throw CodeParseError.wrongLength(expected: Self.length, actual: symbols.count)
        }
        for character in symbols {
            if CrockfordBase32.ambiguousCharacters.contains(character) {
                throw CodeParseError.ambiguousCharacter(character)
            }
            guard CrockfordBase32.isValidSymbol(character) else {
                throw CodeParseError.invalidCharacter(character)
            }
        }

        self.init(unchecked: symbols)
    }

    /// A freshly generated code. Deterministic when a seeded generator is supplied.
    public init<G: RandomNumberGenerator>(using generator: inout G) {
        self.init(unchecked: CrockfordBase32.randomString(length: Self.length, using: &generator))
    }

    /// A freshly generated code from the system's secure random source.
    public init() {
        var generator = SystemRandomNumberGenerator()
        self.init(using: &generator)
    }

    /// Display form, e.g. `DEN·ABCD-EFGH`. Never store this — store `rawValue`.
    public var formatted: String {
        let midpoint = rawValue.index(rawValue.startIndex, offsetBy: rawValue.count / 2)
        let head = rawValue[..<midpoint]
        let tail = rawValue[midpoint...]
        return "\(Self.prefix)\(Self.prefixSeparator)\(head)-\(tail)"
    }

    public var description: String { formatted }

    /// True when `input` parses cleanly as this kind of code.
    public static func isValid(_ input: String) -> Bool {
        (try? Self(parsing: input)) != nil
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue == rhs.rawValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }

    // Encoded as a bare string rather than `{"rawValue": …}` so CloudKit fields and JSON
    // fixtures both hold the same eight symbols the user sees. These are deliberately
    // *not* named `init(from:)` / `encode(to:)`: a protocol-extension member with those
    // names competes with Swift's synthesised Codable conformance, and which one wins is
    // not something to leave to chance. Each concrete code type forwards to them.
    public init(decodingFrom decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        try self.init(parsing: container.decode(String.self))
    }

    public func encodeRawValue(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
