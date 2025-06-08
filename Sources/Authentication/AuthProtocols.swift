import Foundation

/// Protocol defining the authentication service interface.
/// This protocol abstracts the authentication functionality, allowing for different implementations
/// and making the code more testable.
public protocol AuthServiceProtocol: Actor {
    /// Indicates whether a user is currently authenticated.
    /// - Returns: `true` if a user is signed in, `false` otherwise
    var isAuthenticated: Bool { get }
    
    /// The currently authenticated user, if any.
    /// - Returns: An `AuthUser` object if authenticated, `nil` otherwise
    var currentUser: AuthUser? { get }
    
    /// Signs in a user with the provided credentials.
    /// - Parameters:
    ///   - credentials: The user's email and password wrapped in `AuthCredentials`
    /// - Returns: An `AuthUser` object representing the authenticated user
    /// - Throws: `AuthError.signInFailed` if authentication fails
    /// - Note: This function must be called from the main actor as it may update UI-related state
    @MainActor
    func signIn(with credentials: AuthCredentials) async throws -> AuthUser
    
    /// Creates a new user account and signs them in.
    /// - Parameters:
    ///   - credentials: The user's email and password wrapped in `AuthCredentials`
    ///   - name: The user's display name
    /// - Returns: An `AuthUser` object representing the newly created and authenticated user
    /// - Throws: `AuthError.signUpFailed` if account creation fails
    /// - Note: This function must be called from the main actor as it may update UI-related state
    @MainActor
    func signUp(with credentials: AuthCredentials, name: String) async throws -> AuthUser
    
    /// Signs out the current user.
    /// - Throws: `AuthError.signOutFailed` if sign out fails
    /// - Note: After successful sign out, `isAuthenticated` will return `false` and `currentUser` will be `nil`
    func signOut() throws
    
    /// Retrieves the authentication token for the current user.
    /// - Returns: A string containing the authentication token
    /// - Throws: `AuthError.notAuthenticated` if no user is authenticated
    /// - Note: This token should be included in API requests that require authentication
    func getToken() throws -> String
}
