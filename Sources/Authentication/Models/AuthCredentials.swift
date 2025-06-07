import Foundation

/// Credentials used for authentication (sign in/sign up).
/// Conforms to `Codable` for easy serialization and `Sendable` for safe concurrent access.
public struct AuthCredentials: Codable, Sendable {
    /// User's email address
    public let email: String
    /// User's password (should be transmitted securely)
    public let password: String
    
    /// Creates new authentication credentials.
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
