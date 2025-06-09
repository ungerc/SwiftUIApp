import Foundation

/// Errors that can occur during authentication operations.
enum AuthError: Error, Identifiable {
    public var id: Self { self }

    /// Thrown when sign in fails due to invalid credentials or network issues
    case signInFailed
    /// Thrown when account creation fails due to invalid data or existing account
    case signUpFailed
    /// Thrown when sign out operation fails
    case signOutFailed
    /// Thrown when attempting to access authenticated resources without being signed in
    case notAuthenticated
}

extension AuthError: LocalizedError {
    public var localizedDescription: String? {
        switch self {
        case .signInFailed:
            return "Sign in failed. Please check your credentials and try again."
        case .signUpFailed:
            return "Sign up failed. Please check your email address and try again."
        case .signOutFailed:
            return "Sign out failed. Please try again."
        case .notAuthenticated:
            return "You are not signed in."
        }
    }
}
