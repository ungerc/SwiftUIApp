import XCTest
@testable import Authentication

final class AuthManagerTests: XCTestCase {
    var authManager: AuthManager!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        authManager = AuthManager(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        authManager = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    // MARK: - Sign In Tests
    
    @MainActor
    func testSignInSuccess() async throws {
        // Given
        let credentials = AuthCredentials(email: "test@example.com", password: "password123")
        
        // When
        let user = try await authManager.signIn(with: credentials)
        
        // Then
        XCTAssertEqual(user.email, credentials.email)
        XCTAssertEqual(user.name, "Peter Petersen")
        XCTAssertTrue(authManager.isAuthenticated)
        XCTAssertNotNil(authManager.currentUser)
    }
    
    @MainActor
    func testSignInUpdatesAuthenticationState() async throws {
        // Given
        XCTAssertFalse(authManager.isAuthenticated)
        let credentials = AuthCredentials(email: "test@example.com", password: "password123")
        
        // When
        _ = try await authManager.signIn(with: credentials)
        
        // Then
        XCTAssertTrue(authManager.isAuthenticated)
    }
    
    // MARK: - Sign Up Tests
    
    @MainActor
    func testSignUpSuccess() async throws {
        // Given
        let credentials = AuthCredentials(email: "newuser@example.com", password: "password123")
        let name = "New User"
        
        // When
        let user = try await authManager.signUp(with: credentials, name: name)
        
        // Then
        XCTAssertEqual(user.email, credentials.email)
        XCTAssertEqual(user.name, name)
        XCTAssertTrue(authManager.isAuthenticated)
        XCTAssertNotNil(authManager.currentUser)
    }
    
    // MARK: - Sign Out Tests
    
    func testSignOutSuccess() throws {
        // Given - Set up authenticated state
        authManager.currentUser = AuthUser(id: "1", email: "test@example.com", name: "Test User")
        authManager.setValue("mock-token", forKey: "authToken")
        XCTAssertTrue(authManager.isAuthenticated)
        
        // When
        try authManager.signOut()
        
        // Then
        XCTAssertFalse(authManager.isAuthenticated)
        XCTAssertNil(authManager.currentUser)
    }
    
    // MARK: - Token Tests
    
    func testGetTokenWhenAuthenticated() throws {
        // Given - Mock authenticated state
        authManager.currentUser = AuthUser(id: "1", email: "test@example.com", name: "Test User")
        authManager.setValue("mock-token-123", forKey: "authToken")
        
        // When/Then - Currently returns hardcoded value
        let token = try authManager.getToken()
        XCTAssertEqual(token, "ABD#$DFRG$^")
    }
    
    func testGetTokenWhenNotAuthenticated() throws {
        // Given
        XCTAssertFalse(authManager.isAuthenticated)
        
        // When/Then - Currently returns hardcoded value regardless of auth state
        let token = try authManager.getToken()
        XCTAssertEqual(token, "ABD#$DFRG$^")
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
