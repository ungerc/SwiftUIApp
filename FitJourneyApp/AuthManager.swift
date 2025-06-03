import Foundation

class AuthManager {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    private(set) var currentUser: User?
    private var authToken: String?

    var isAuthenticated: Bool {
        return currentUser != nil && authToken != nil
    }

    func getToken() throws -> String {
        guard let token = authToken else {
            throw AuthError.notAuthenticated
        }
        return token
    }

    @discardableResult
    func signIn(with credentials: AuthCredentials) async throws -> User {
        // Mock implementation
        let user = User(id: "1", email: credentials.email, name: "Test User")
        self.currentUser = user
        self.authToken = "mock-token"
        return user
    }

    @discardableResult
    func signUp(with credentials: AuthCredentials, name: String) async throws -> User {
        // Mock implementation
        let user = User(id: "1", email: credentials.email, name: name)
        self.currentUser = user
        self.authToken = "mock-token"
        return user
    }

    func signOut() throws {
        self.currentUser = nil
        self.authToken = nil
    }
}

struct User: Codable {
    public let id: String
    public let email: String
    public let name: String

    public init(id: String, email: String, name: String) {
        self.id = id
        self.email = email
        self.name = name
    }
}

struct AuthCredentials: Codable {
    public let email: String
    public let password: String

    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

enum AuthError: Error {
    case signInFailed
    case signUpFailed
    case signOutFailed
    case notAuthenticated
}
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
