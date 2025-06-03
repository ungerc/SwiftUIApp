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
