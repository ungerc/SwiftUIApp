import SwiftUI

@Observable
@MainActor
public class AuthViewModel {
    private let authService: AuthServiceProtocol
    
    public private(set) var isLoading = false
    public private(set) var errorMessage: String?
    public var isAuthenticated: Bool {
        authService.isAuthenticated
    }
    
    public var currentUser: AuthUser? {
        authService.currentUser
    }
    
    public init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    public func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let credentials = AuthCredentials(email: email, password: password)
            try await authService.signIn(with: credentials)
        } catch {
            errorMessage = "Failed to sign in. Please check your credentials."
        }
        
        isLoading = false
    }
    
    public func signUp(name: String, email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let credentials = AuthCredentials(email: email, password: password)
            try await authService.signUp(with: credentials, name: name)
        } catch {
            errorMessage = "Failed to create account. Please try again."
        }
        
        isLoading = false
    }
    
    public func signOut() {
        do {
            try authService.signOut()
        } catch {
            errorMessage = "Failed to sign out."
        }
    }
}
