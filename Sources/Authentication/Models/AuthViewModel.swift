import SwiftUI

/// View model for authentication-related UI.
/// Handles the presentation logic for sign in, sign up, and authentication state.
/// Marked with @Observable for SwiftUI integration and @MainActor to ensure UI updates on main thread.
@Observable
@MainActor
public class AuthViewModel {
    /// The underlying authentication service
    private let authService: AuthServiceProtocol
    
    /// Indicates whether an authentication operation is in progress
    /// Used to show loading indicators in the UI
    public private(set) var isLoading = false
    
    /// Error message to display to the user, if any
    /// Set to nil when operations succeed or when starting new operations
    var error: AuthError?

    /// Whether the user is currently authenticated
    /// Delegates to the underlying auth service
    public var isAuthenticated: Bool {
        get async {
            await authService.isAuthenticated
        }
    }
    
    /// The currently authenticated user, if any
    /// Delegates to the underlying auth service
    public var currentUser: AuthUser? {
        get async {
            await authService.currentUser
        }
    }
    
    /// Creates a new AuthViewModel instance.
    /// - Parameter authService: The authentication service to use
    public init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    public func signIn(email: String, password: String) async {
        isLoading = true
        error = nil

        do {
            let credentials = AuthCredentials(email: email, password: password)
            _ = try await authService.signIn(with: credentials)
        } catch let error as AuthError {
            self.error = error
        }
        catch {

        }

        isLoading = false
    }
    
    public func signUp(name: String, email: String, password: String) async {
        isLoading = true
        error = nil
        
        do {
            let credentials = AuthCredentials(email: email, password: password)
            _ = try await authService.signUp(with: credentials, name: name)
        } catch let error as AuthError{
            self.error = error
        } catch {

        }

        isLoading = false
    }
    
    public func signOut() async {
        error = nil
        do {
            try await authService.signOut()
        } catch let error as AuthError{
            self.error = error
        } catch {

        }
    }
}
