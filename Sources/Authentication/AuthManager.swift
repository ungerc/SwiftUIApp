import Foundation

/// Main authentication manager that handles user authentication operations.
/// This actor manages the authentication state and provides methods for sign in, sign up, and sign out.
public actor AuthManager: AuthServiceProtocol {
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
    
    /// Signs in a user with the provided credentials.
    /// 
    /// - Parameter credentials: The user's email and password
    /// - Returns: The authenticated user
    /// - Throws: `AuthError.signInFailed` if authentication fails
    /// 
    /// Note: Currently returns mock data for testing. The commented code
    /// shows the actual implementation that will be used when the backend is ready.
    @MainActor
    @discardableResult
    public func signIn(with credentials: AuthCredentials) async throws -> AuthUser {
        // Temporarily using mock data for testing
        await setUser(AuthUser(id: "1", email: credentials.email, name: "Peter Petersen"))
        await setAuthToken("mock-token-123")
        return await self.currentUser!

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

    private func setAuthToken(_ token: String) {
        authToken = token
    }
    private func setUser(_ user: AuthUser) {
        currentUser = user
    }

    /// Creates a new user account and signs them in.
    /// 
    /// - Parameters:
    ///   - credentials: The user's email and password
    ///   - name: The user's display name
    /// - Returns: The newly created and authenticated user
    /// - Throws: `AuthError.signUpFailed` if account creation fails
    /// 
    /// Note: Currently returns mock data for testing. The commented code
    /// shows the actual implementation that will be used when the backend is ready.
    @MainActor
    @discardableResult
    public func signUp(with credentials: AuthCredentials, name: String) async throws -> AuthUser {
        // Temporarily using mock data for testing
        await setUser(AuthUser(id: "1", email: credentials.email, name: name))
        await setAuthToken("mock-token-123")
        return await self.currentUser!

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
    
    /// Signs out the current user.
    /// 
    /// This method clears the local user data and authentication token.
    /// In a production app, this would also invalidate the token on the server.
    /// 
    /// - Throws: Currently doesn't throw but may in the future for server-side operations
    public func signOut() throws {
        // In a real app, you might want to invalidate the token on the server
        self.currentUser = nil
        self.authToken = nil
    }
    
    /// Retrieves the authentication token for the current user.
    /// 
    /// - Returns: The authentication token
    /// - Throws: `AuthError.notAuthenticated` if no user is authenticated
    /// 
    /// Warning: Currently returns a hardcoded token. Proper token management
    /// needs to be implemented for production use.
    public func getToken() throws -> String {
#warning ("Implement proper token management")
        return "ABD#$DFRG$^"

        guard let token = authToken else {
            throw AuthError.notAuthenticated
        }
        return token
    }
}
