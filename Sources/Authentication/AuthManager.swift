import Foundation

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
