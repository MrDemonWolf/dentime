import Foundation

public struct APIError: Error, Sendable {
    public let status: Int
    public let message: String
}

public actor APIClient {
    public static let productionBaseURL = URL(string: "https://dentime.mrdemonwolf.workers.dev")!

    private let baseURL: URL
    private let session: URLSession
    private var sessionToken: String?

    public init(baseURL: URL = APIClient.productionBaseURL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    public func setSessionToken(_ token: String?) {
        self.sessionToken = token
    }

    public func health() async throws -> [String: String] {
        try await get("/health")
    }

    public func me() async throws -> User {
        try await get("/me")
    }

    public func roster() async throws -> [RosterEntry] {
        try await get("/me/roster")
    }

    private func get<T: Decodable>(_ path: String) async throws -> T {
        var req = URLRequest(url: baseURL.appendingPathComponent(path))
        if let token = sessionToken {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let (data, response) = try await session.data(for: req)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            let status = (response as? HTTPURLResponse)?.statusCode ?? -1
            let body = String(data: data, encoding: .utf8) ?? ""
            throw APIError(status: status, message: body)
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
    }
}
