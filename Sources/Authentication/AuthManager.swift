import Foundation

/// Protocol for network services that can handle authentication-related requests.
/// This abstraction allows for easy mocking in tests and swapping implementations.
public protocol AuthNetworkService {
    /// Sends a POST request with an encodable body and expects a decodable response.
    /// - Parameters:
    ///   - urlString: The URL to send the request to
    ///   - body: The encodable data to send in the request body
    /// - Returns: The decoded response of type `U`
    /// - Throws: Network-related errors or decoding errors
    func post<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U
}

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

/// Represents an authenticated user in the system.
/// Conforms to `Codable` for easy serialization and `Sendable` for safe concurrent access.
public struct AuthUser: Codable, Sendable {
    /// Unique identifier for the user
    public let id: String
    /// User's email address (used for authentication)
    public let email: String
    /// User's display name
    public let name: String
    
    /// Creates a new AuthUser instance.
    /// - Parameters:
    ///   - id: Unique identifier for the user
    ///   - email: User's email address
    ///   - name: User's display name
    public init(id: String, email: String, name: String) {
        self.id = id
        self.email = email
        self.name = name
    }
}

/// Credentials used for authentication (sign in/sign up).
/// Conforms to `Codable` for easy serialization and `Sendable` for safe concurrent access.
public struct AuthCredentials: Codable, Sendable {
    /// User's email address
    public let email: String
    /// User's password (should be transmitted securely)
    public let password: String
    
    /// Creates new authentication credentials.
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

/// Response from authentication endpoints containing user data and auth token.
/// Conforms to `Codable` for easy deserialization and `Sendable` for safe concurrent access.
public struct AuthResponse: Codable, Sendable {
    /// The authenticated user's information
    public let user: AuthUser
    /// Authentication token to be used for subsequent API requests
    public let token: String
}

/// Main authentication manager that handles user authentication operations.
/// This class manages the authentication state and provides methods for sign in, sign up, and sign out.
public class AuthManager: AuthServiceProtocol {
    /// Network service used for making authentication API calls
    private let networkService: AuthNetworkService
    
    /// Creates a new AuthManager instance.
    /// - Parameter networkService: The network service to use for API calls
    public init(networkService: AuthNetworkService) {
        self.networkService = networkService
    }
    
    /// Base URL for authentication endpoints
    private let baseURL = "https://api.fitjourney.com/auth"
    
    /// The currently authenticated user (read-only from outside the class)
    public private(set) var currentUser: AuthUser?
    
    /// The authentication token for the current session
    private var authToken: String?
    
    /// Indicates whether a user is currently authenticated.
    /// A user is considered authenticated if both user data and auth token are present.
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
