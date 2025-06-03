import Foundation
import AppCore

// This file should be created or updated to use the adapter pattern
public class AuthManager {
    private let authAdapter: ApplicationAuthAdapter
    
    public init(authAdapter: ApplicationAuthAdapter) {
        self.authAdapter = authAdapter
    }
    
    public var isAuthenticated: Bool {
        return authAdapter.isAuthenticated
    }
    
    public var currentUser: User? {
        return authAdapter.currentUser
    }
    
    public func signIn(email: String, password: String) async throws -> User {
        return try await authAdapter.signIn(email: email, password: password)
    }
    
    public func signUp(email: String, password: String, name: String) async throws -> User {
        return try await authAdapter.signUp(email: email, password: password, name: name)
    }
    
    public func signOut() throws {
        try authAdapter.signOut()
    }
    
    public func getToken() throws -> String {
        return try authAdapter.getToken()
    }
}

// Using the types from AppCore
public typealias User = AppCore.User
public typealias AuthError = Error
