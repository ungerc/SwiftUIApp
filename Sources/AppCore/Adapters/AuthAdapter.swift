import Foundation
import Authentication

// This adapter exposes the AuthServiceProtocol to other modules
// without them needing to import Authentication directly
public class AuthAdapter {
    private let authService: AuthServiceProtocol
    
    public init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    public var isAuthenticated: Bool {
        return authService.isAuthenticated
    }
    
    public var currentUser: User? {
        return authService.currentUser
    }
    
    public func signIn(email: String, password: String) async throws -> User {
        let credentials = AuthCredentials(email: email, password: password)
        return try await authService.signIn(with: credentials)
    }
    
    public func signUp(name: String, email: String, password: String) async throws -> User {
        let credentials = AuthCredentials(email: email, password: password)
        return try await authService.signUp(with: credentials, name: name)
    }
    
    public func signOut() throws {
        try authService.signOut()
    }
    
    public func getToken() throws -> String {
        return try authService.getToken()
    }
}
