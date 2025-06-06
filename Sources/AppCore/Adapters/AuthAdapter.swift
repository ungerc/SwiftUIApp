import Foundation
import SwiftUI
import Authentication

// This adapter exposes the AuthServiceProtocol and AuthView to other modules
// without them needing to import Authentication directly
internal class AuthAdapter {
    private let authService: AuthServiceProtocol
    
    public init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    public var isAuthenticated: Bool {
        return authService.isAuthenticated
    }
    
    public var currentUser: AuthUser? {
        return authService.currentUser
    }
    
    @MainActor
    public func signIn(email: String, password: String) async throws -> AuthUser {
        let credentials = AuthCredentials(email: email, password: password)
        return try await authService.signIn(with: credentials)
    }
    
    @MainActor
    public func signUp(name: String, email: String, password: String) async throws -> AuthUser {
        let credentials = AuthCredentials(email: email, password: password)
        return try await authService.signUp(with: credentials, name: name)
    }
    
    public func signOut() throws {
        try authService.signOut()
    }
    
    public func getToken() throws -> String {
        return try authService.getToken()
    }
    
    // Expose the AuthView with the proper environment setup
    @MainActor
    public func makeAuthView() -> AnyView {
        AnyView(
            AuthView()
                .environment(AuthViewModel(authService: authService))
        )
    }
}
