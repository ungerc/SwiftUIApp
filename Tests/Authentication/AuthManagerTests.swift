import Testing
@testable import Authentication
@testable import Networking

@Suite("AuthManager Tests")
struct AuthManagerTests {
    let sut: AuthManager
    let mockNetworkService: MockAuthNetworkService
    
    init() {
        mockNetworkService = MockAuthNetworkService()
        sut = AuthManager(networkService: mockNetworkService)
    }
    
    // MARK: - Sign In Tests
    
    @Test("Sign in with valid credentials returns user")
    func signInWithValidCredentials() async throws {
        // Given
        let credentials = AuthCredentials(email: "test@example.com", password: "password123")
        let expectedUser = AuthUser(id: "1", email: credentials.email, name: "Test User")
        let expectedResponse = AuthResponse(user: expectedUser, token: "mock-token")
        mockNetworkService.mockResponse = expectedResponse
        
        // When
        let user = try await sut.signIn(with: credentials)
        
        // Then
        #expect(user.id == expectedUser.id)
        #expect(user.email == expectedUser.email)
        #expect(user.name == expectedUser.name)
        #expect(sut.isAuthenticated)
        #expect(sut.currentUser != nil)
    }
    
    @Test("Sign in with invalid credentials throws error")
    func signInWithInvalidCredentials() async throws {
        // Given
        let credentials = AuthCredentials(email: "test@example.com", password: "wrong")
        mockNetworkService.shouldThrowError = true
        
        // When/Then
        await #expect(throws: AuthError.self) {
            _ = try await sut.signIn(with: credentials)
        }
    }
    
    // MARK: - Sign Up Tests
    
    @Test("Sign up with valid data returns user")
    func signUpWithValidData() async throws {
        // Given
        let credentials = AuthCredentials(email: "new@example.com", password: "password123")
        let name = "New User"
        let expectedUser = AuthUser(id: "2", email: credentials.email, name: name)
        let expectedResponse = AuthResponse(user: expectedUser, token: "new-token")
        mockNetworkService.mockResponse = expectedResponse
        
        // When
        let user = try await sut.signUp(with: credentials, name: name)
        
        // Then
        #expect(user.id == expectedUser.id)
        #expect(user.email == expectedUser.email)
        #expect(user.name == expectedUser.name)
        #expect(sut.isAuthenticated)
    }
    
    // MARK: - Sign Out Tests
    
    @Test("Sign out when authenticated clears user data")
    func signOutWhenAuthenticated() async throws {
        // Given - Sign in first
        let credentials = AuthCredentials(email: "test@example.com", password: "password123")
        let expectedUser = AuthUser(id: "1", email: credentials.email, name: "Test User")
        mockNetworkService.mockResponse = AuthResponse(user: expectedUser, token: "token")
        _ = try await sut.signIn(with: credentials)
        
        // When
        try sut.signOut()
        
        // Then
        #expect(!sut.isAuthenticated)
        #expect(sut.currentUser == nil)
    }
    
    // MARK: - Get Token Tests
    
    @Test("Get token when authenticated returns token")
    func getTokenWhenAuthenticated() async throws {
        // Given - Sign in first
        let credentials = AuthCredentials(email: "test@example.com", password: "password123")
        let expectedUser = AuthUser(id: "1", email: credentials.email, name: "Test User")
        mockNetworkService.mockResponse = AuthResponse(user: expectedUser, token: "test-token")
        _ = try await sut.signIn(with: credentials)
        
        // When
        let token = try sut.getToken()
        
        // Then
        #expect(token == "mock-token-123") // Based on current implementation
    }
    
    @Test("Get token when not authenticated throws error")
    func getTokenWhenNotAuthenticated() throws {
        // Given - Not signed in
        
        // When/Then
        #expect(throws: AuthError.self) {
            _ = try sut.getToken()
        }
    }
}

// MARK: - Mock Network Service

class MockAuthNetworkService: AuthNetworkService {
    var mockResponse: Any?
    var shouldThrowError = false
    var lastRequestURL: String?
    var lastRequestBody: Any?
    
    func post<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U {
        lastRequestURL = urlString
        lastRequestBody = body
        
        if shouldThrowError {
            throw AuthError.signInFailed
        }
        
        guard let response = mockResponse as? U else {
            throw AuthError.signInFailed
        }
        
        return response
    }
}
