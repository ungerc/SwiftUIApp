import Foundation

/// Represents an authenticated user in the system.
/// Conforms to `Codable` for easy serialization and `Sendable` for safe concurrent access.
public struct AuthUser: Codable, Sendable {
    /// Unique identifier for the user
    public let id: String
    /// User's email address (used for authentication)
    public let email: String
    /// User's display name
    public let name: String
    
    /// Creates a new AuthUser instance.
    /// - Parameters:
    ///   - id: Unique identifier for the user
    ///   - email: User's email address
    ///   - name: User's display name
    public init(id: String, email: String, name: String) {
        self.id = id
        self.email = email
        self.name = name
    }
}
