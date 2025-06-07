import Foundation

/// Errors that can occur during authentication operations.
public enum AuthError: Error {
    /// Thrown when sign in fails due to invalid credentials or network issues
    case signInFailed
    /// Thrown when account creation fails due to invalid data or existing account
    case signUpFailed
    /// Thrown when sign out operation fails
    case signOutFailed
    /// Thrown when attempting to access authenticated resources without being signed in
    case notAuthenticated
}
