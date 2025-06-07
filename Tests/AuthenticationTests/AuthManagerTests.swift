import Testing
@testable import Authentication

@Suite("AuthManager Tests")
struct AuthManagerTests {
    let mockNetworkService = MockNetworkService()
    var authManager: AuthManager {
        AuthManager(networkService: mockNetworkService)
    }
    
    // MARK: - Sign In Tests
    
    @Test("Sign in with valid credentials")
    @MainActor
    func signInSuccess() async throws {
        // Given
        let credentials = AuthCredentials(email: "test@example.com", password: "password123")
        let manager = authManager
        
        // When
        let user = try await manager.signIn(with: credentials)
        
        // Then
        #expect(user.email == credentials.email)
        #expect(user.name == "Peter Petersen")
        #expect(manager.isAuthenticated)
        #expect(manager.currentUser != nil)
    }
    
    @Test("Sign in updates authentication state")
    @MainActor
    func signInUpdatesAuthenticationState() async throws {
        // Given
        let manager = authManager
        #expect(!manager.isAuthenticated)
        let credentials = AuthCredentials(email: "test@example.com", password: "password123")
        
        // When
        _ = try await manager.signIn(with: credentials)
        
        // Then
        #expect(manager.isAuthenticated)
    }
    
    // MARK: - Sign Up Tests
    
    @Test("Sign up with new user")
    @MainActor
    func signUpSuccess() async throws {
        // Given
        let credentials = AuthCredentials(email: "newuser@example.com", password: "password123")
        let name = "New User"
        let manager = authManager
        
        // When
        let user = try await manager.signUp(with: credentials, name: name)
        
        // Then
        #expect(user.email == credentials.email)
        #expect(user.name == name)
        #expect(manager.isAuthenticated)
        #expect(manager.currentUser != nil)
    }
    
    // MARK: - Sign Out Tests
    
    @Test("Sign out clears authentication")
    @MainActor
    func signOutSuccess() async throws {
        // Given - Set up authenticated state by signing in
        let manager = authManager
        let credentials = AuthCredentials(email: "test@example.com", password: "password123")
        _ = try await manager.signIn(with: credentials)
        #expect(manager.isAuthenticated)
        
        // When
        try manager.signOut()
        
        // Then
        #expect(!manager.isAuthenticated)
        #expect(manager.currentUser == nil)
    }
    
    // MARK: - Token Tests
    
    @Test("Get token returns hardcoded value")
    @MainActor
    func getTokenWhenAuthenticated() async throws {
        // Given - Sign in to set authenticated state
        let manager = authManager
        let credentials = AuthCredentials(email: "test@example.com", password: "password123")
        _ = try await manager.signIn(with: credentials)
        
        // When/Then - Currently returns hardcoded value
        let token = try manager.getToken()
        #expect(token == "ABD#$DFRG$^")
    }
    
    @Test("Get token works when not authenticated")
    func getTokenWhenNotAuthenticated() throws {
        // Given
        let manager = authManager
        #expect(!manager.isAuthenticated)
        
        // When/Then - Currently returns hardcoded value regardless of auth state
        let token = try manager.getToken()
        #expect(token == "ABD#$DFRG$^")
    }
}

// MARK: - Mock Network Service

class MockNetworkService: AuthNetworkService {
    var shouldThrowError = false
    var postCallCount = 0
    var lastPostedURL: String?
    var lastPostedBody: Any?
    
    func post<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U {
        postCallCount += 1
        lastPostedURL = urlString
        lastPostedBody = body
        
        if shouldThrowError {
            throw AuthError.signInFailed
        }
        
        // Return mock response based on the expected type
        if U.self == AuthResponse.self {
            let mockUser = AuthUser(id: "1", email: "test@example.com", name: "Test User")
            let mockResponse = AuthResponse(user: mockUser, token: "mock-token-123")
            return mockResponse as! U
        }
        
        throw AuthError.signInFailed
    }
}
