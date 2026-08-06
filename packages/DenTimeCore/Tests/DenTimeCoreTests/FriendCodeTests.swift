import Foundation
import XCTest

@testable import DenTimeCore

final class FriendCodeTests: XCTestCase {
    // MARK: - Generation

    func testGeneratedCodeIsEightLegalSymbols() {
        var generator = SeededGenerator(seed: 42)
        for _ in 0 ..< 500 {
            let code = FriendCode(using: &generator)
            XCTAssertEqual(code.rawValue.count, 8)
            for character in code.rawValue {
                XCTAssertTrue(
                    CrockfordBase32.isValidSymbol(character),
                    "\(character) is not in the Crockford alphabet"
                )
                XCTAssertFalse(
                    CrockfordBase32.ambiguousCharacters.contains(character),
                    "\(character) is ambiguous and must never be generated"
                )
            }
        }
    }

    func testGenerationIsDeterministicForASeededGenerator() {
        var first = SeededGenerator(seed: 7)
        var second = SeededGenerator(seed: 7)
        XCTAssertEqual(FriendCode(using: &first), FriendCode(using: &second))
    }

    func testAlphabetHasThirtyTwoSymbolsAndExcludesTheAmbiguousFour() {
        XCTAssertEqual(CrockfordBase32.alphabet.count, 32)
        for character in "ILOU" {
            XCTAssertFalse(CrockfordBase32.alphabet.contains(character))
        }
    }

    // MARK: - Formatting

    func testFormattedUsesPrefixMiddleDotAndHyphen() {
        let code = FriendCode(unchecked: "ABCD2345")
        XCTAssertEqual(code.formatted, "DEN\u{00B7}ABCD-2345")
        XCTAssertEqual(code.description, code.formatted)
    }

    func testJoinCodeUsesItsOwnPrefix() {
        let code = JoinCode(unchecked: "ABCD2345")
        XCTAssertEqual(code.formatted, "HOWL\u{00B7}ABCD-2345")
    }

    // MARK: - Parsing

    func testRoundTripThroughFormattedForm() throws {
        var generator = SeededGenerator(seed: 99)
        for _ in 0 ..< 200 {
            let original = FriendCode(using: &generator)
            let parsed = try FriendCode(parsing: original.formatted)
            XCTAssertEqual(parsed, original)
            XCTAssertEqual(parsed.rawValue, original.rawValue)
        }
    }

    func testParsingToleratesCaseWhitespaceAndMissingSeparators() throws {
        let expected = FriendCode(unchecked: "ABCD2345")
        for input in [
            "DEN\u{00B7}ABCD-2345",
            "den\u{00B7}abcd-2345",
            "  DEN\u{00B7}ABCD-2345  ",
            "ABCD-2345",
            "abcd2345",
            "ABCD 2345",
            "DEN ABCD 2345",
            "DEN-ABCD-2345",
            "ABCD_2345",
        ] {
            XCTAssertEqual(try FriendCode(parsing: input), expected, "failed on \(input)")
        }
    }

    func testParsingRejectsAmbiguousCharacters() {
        // Canonical Crockford would decode these; DenTime refuses them outright so there
        // is never a silently-corrected variant of somebody's code in circulation.
        for character in "ILOU" {
            let input = "ABCD234\(character)"
            XCTAssertThrowsError(try FriendCode(parsing: input)) { error in
                XCTAssertEqual(
                    error as? CodeParseError,
                    .ambiguousCharacter(character),
                    "expected \(character) to be rejected as ambiguous"
                )
            }
        }
    }

    func testParsingRejectsWrongLength() {
        XCTAssertThrowsError(try FriendCode(parsing: "ABCD234")) { error in
            XCTAssertEqual(error as? CodeParseError, .wrongLength(expected: 8, actual: 7))
        }
        XCTAssertThrowsError(try FriendCode(parsing: "ABCD23456")) { error in
            XCTAssertEqual(error as? CodeParseError, .wrongLength(expected: 8, actual: 9))
        }
        XCTAssertThrowsError(try FriendCode(parsing: "")) { error in
            XCTAssertEqual(error as? CodeParseError, .wrongLength(expected: 8, actual: 0))
        }
    }

    func testParsingRejectsCharactersOutsideTheAlphabet() {
        XCTAssertThrowsError(try FriendCode(parsing: "ABCD234!")) { error in
            XCTAssertEqual(error as? CodeParseError, .invalidCharacter("!"))
        }
    }

    func testParsingRejectsTheOtherCodeTypesPrefix() {
        XCTAssertThrowsError(try FriendCode(parsing: "HOWL\u{00B7}ABCD-2345")) { error in
            XCTAssertEqual(error as? CodeParseError, .wrongPrefix(expected: "DEN", actual: "HOWL"))
        }
        XCTAssertThrowsError(try JoinCode(parsing: "DEN\u{00B7}ABCD-2345")) { error in
            XCTAssertEqual(error as? CodeParseError, .wrongPrefix(expected: "HOWL", actual: "DEN"))
        }
    }

    func testACodeBeginningWithItsOwnPrefixLettersIsNotTruncated() throws {
        // "DENP2345" is a legal eight-symbol code. Stripping the prefix only when a
        // separator follows it is what keeps this from being read as "P2345".
        let code = FriendCode(unchecked: "DENP2345")
        XCTAssertEqual(try FriendCode(parsing: "DENP2345"), code)
        XCTAssertEqual(try FriendCode(parsing: code.formatted), code)
    }

    func testIsValid() {
        XCTAssertTrue(FriendCode.isValid("DEN\u{00B7}ABCD-2345"))
        XCTAssertTrue(FriendCode.isValid("abcd2345"))
        XCTAssertFalse(FriendCode.isValid("ABCD234I"))
        XCTAssertFalse(FriendCode.isValid("nope"))
    }

    // MARK: - Codable

    func testEncodesAsABareStringNotAnObject() throws {
        let code = FriendCode(unchecked: "ABCD2345")
        let data = try JSONEncoder().encode(["code": code])
        let json = String(decoding: data, as: UTF8.self)
        XCTAssertEqual(json, #"{"code":"ABCD2345"}"#)

        let decoded = try JSONDecoder().decode([String: FriendCode].self, from: data)
        XCTAssertEqual(decoded["code"], code)
    }

    func testDecodingRejectsAnInvalidStoredValue() {
        let data = Data(#"{"code":"ABCD234I"}"#.utf8)
        XCTAssertThrowsError(try JSONDecoder().decode([String: FriendCode].self, from: data))
    }
}
