import Foundation

public protocol AuthNetworkService {
    func post<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U
}

public enum AuthError: Error {
    case signInFailed
    case signUpFailed
    case signOutFailed
    case notAuthenticated
}

public struct AuthUser: Codable, Sendable {
    public let id: String
    public let email: String
    public let name: String
    
    public init(id: String, email: String, name: String) {
        self.id = id
        self.email = email
        self.name = name
    }
}

public struct AuthCredentials: Codable, Sendable {
    public let email: String
    public let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

public struct AuthResponse: Codable, Sendable {
    public let user: AuthUser
    public let token: String
}

public class AuthManager: AuthServiceProtocol {
    private let networkService: AuthNetworkService
    
    public init(networkService: AuthNetworkService) {
        self.networkService = networkService
    }
    private let baseURL = "https://api.fitjourney.com/auth"
    
    public private(set) var currentUser: AuthUser?
    private var authToken: String?
    
    public var isAuthenticated: Bool {
        return currentUser != nil && authToken != nil
    }
    
    @MainActor
    @discardableResult
    public func signIn(with credentials: AuthCredentials) async throws -> AuthUser {
        // Temporarily using mock data for testing
        self.currentUser = AuthUser(id: "1", email: credentials.email, name: "Peter Petersen")
        self.authToken = "mock-token-123"
        return self.currentUser!

        // TODO: Uncomment when backend is ready
        /*
        do {
            let response: AuthResponse = try await networkService.post(
                to: "\(baseURL)/signin",
                body: credentials
            )
            
            self.currentUser = response.user
            self.authToken = response.token
            
            return response.user
        } catch {
            throw AuthError.signInFailed
        }
        */
    }
    
    @MainActor
    @discardableResult
    public func signUp(with credentials: AuthCredentials, name: String) async throws -> AuthUser {
        // Temporarily using mock data for testing
        self.currentUser = AuthUser(id: "1", email: credentials.email, name: name)
        self.authToken = "mock-token-123"
        return self.currentUser!
        
        // TODO: Uncomment when backend is ready
        /*
        struct SignUpRequest: Codable {
            let email: String
            let password: String
            let name: String
        }
        
        let request = SignUpRequest(
            email: credentials.email,
            password: credentials.password,
            name: name
        )
        
        do {
            let response: AuthResponse = try await networkService.post(
                to: "\(baseURL)/signup",
                body: request
            )
            
            self.currentUser = response.user
            self.authToken = response.token
            
            return response.user
        } catch {
            throw AuthError.signUpFailed
        }
        */
    }
    
    public func signOut() throws {
        // In a real app, you might want to invalidate the token on the server
        self.currentUser = nil
        self.authToken = nil
    }
    
    public func getToken() throws -> String {
#warning ("Implement proper token management")
        return "ABD#$DFRG$^"

        guard let token = authToken else {
            throw AuthError.notAuthenticated
        }
        return token
    }
}
