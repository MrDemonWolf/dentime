import Foundation

public enum FriendCode {
    public static func format(_ raw: String) -> String {
        let normalized = normalize(raw)
        guard normalized.count == 8 else { return normalized }
        let idx = normalized.index(normalized.startIndex, offsetBy: 4)
        return "\(normalized[..<idx])-\(normalized[idx...])"
    }

    public static func normalize(_ input: String) -> String {
        input.uppercased().filter { ("0"..."9").contains($0) || ("A"..."Z").contains($0) }
    }
}
