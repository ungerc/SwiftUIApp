import Foundation

/// Response from authentication endpoints containing user data and auth token.
/// Conforms to `Codable` for easy deserialization and `Sendable` for safe concurrent access.
public struct AuthResponse: Codable, Sendable {
    /// The authenticated user's information
    public let user: AuthUser
    /// Authentication token to be used for subsequent API requests
    public let token: String
}
