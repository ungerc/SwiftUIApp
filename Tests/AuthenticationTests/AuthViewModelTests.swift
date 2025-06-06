import XCTest
@testable import Authentication

@MainActor
final class AuthViewModelTests: XCTestCase {
    var viewModel: AuthViewModel!
    var mockAuthService: MockAuthService!
    
    override func setUp() {
        super.setUp()
        mockAuthService = MockAuthService()
        viewModel = AuthViewModel(authService: mockAuthService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAuthService = nil
        super.tearDown()
    }
    
    // MARK: - Sign In Tests
    
    func testSignInSuccess() async {
        // Given
        mockAuthService.signInResult = .success(AuthUser(id: "1", email: "test@example.com", name: "Test User"))
        
        // When
        await viewModel.signIn(email: "test@example.com", password: "password123")
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.isAuthenticated)
    }
    
    func testSignInFailure() async {
        // Given
        mockAuthService.signInResult = .failure(AuthError.signInFailed)
        
        // When
        await viewModel.signIn(email: "test@example.com", password: "wrongpassword")
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "Failed to sign in. Please check your credentials.")
        XCTAssertFalse(viewModel.isAuthenticated)
    }
    
    func testSignInSetsLoadingState() async {
        // Given
        mockAuthService.signInDelay = 0.1
        
        // When
        let signInTask = Task {
            await viewModel.signIn(email: "test@example.com", password: "password123")
        }
        
        // Then - Check loading state is set immediately
        try? await Task.sleep(nanoseconds: 10_000_000) // 0.01 seconds
        XCTAssertTrue(viewModel.isLoading)
        
        await signInTask.value
        XCTAssertFalse(viewModel.isLoading)
    }
    
    // MARK: - Sign Up Tests
    
    func testSignUpSuccess() async {
        // Given
        mockAuthService.signUpResult = .success(AuthUser(id: "1", email: "new@example.com", name: "New User"))
        
        // When
        await viewModel.signUp(name: "New User", email: "new@example.com", password: "password123")
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.isAuthenticated)
    }
    
    func testSignUpFailure() async {
        // Given
        mockAuthService.signUpResult = .failure(AuthError.signUpFailed)
        
        // When
        await viewModel.signUp(name: "New User", email: "new@example.com", password: "password123")
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "Failed to create account. Please try again.")
        XCTAssertFalse(viewModel.isAuthenticated)
    }
    
    // MARK: - Sign Out Tests
    
    func testSignOutSuccess() {
        // Given
        mockAuthService.isAuthenticated = true
        
        // When
        viewModel.signOut()
        
        // Then
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(mockAuthService.isAuthenticated)
    }
    
    func testSignOutFailure() {
        // Given
        mockAuthService.signOutShouldThrow = true
        
        // When
        viewModel.signOut()
        
        // Then
        XCTAssertEqual(viewModel.errorMessage, "Failed to sign out.")
    }
}

// MARK: - Mock Auth Service

@MainActor
class MockAuthService: AuthServiceProtocol {
    var isAuthenticated = false
    var currentUser: AuthUser?
    var signInResult: Result<AuthUser, Error> = .success(AuthUser(id: "1", email: "test@example.com", name: "Test User"))
    var signUpResult: Result<AuthUser, Error> = .success(AuthUser(id: "1", email: "test@example.com", name: "Test User"))
    var signOutShouldThrow = false
    var signInDelay: TimeInterval = 0
    
    func signIn(with credentials: AuthCredentials) async throws -> AuthUser {
        if signInDelay > 0 {
            try? await Task.sleep(nanoseconds: UInt64(signInDelay * 1_000_000_000))
        }
        
        switch signInResult {
        case .success(let user):
            self.currentUser = user
            self.isAuthenticated = true
            return user
        case .failure(let error):
            throw error
        }
    }
    
    func signUp(with credentials: AuthCredentials, name: String) async throws -> AuthUser {
        switch signUpResult {
        case .success(let user):
            self.currentUser = user
            self.isAuthenticated = true
            return user
        case .failure(let error):
            throw error
        }
    }
    
    func signOut() throws {
        if signOutShouldThrow {
            throw AuthError.signOutFailed
        }
        self.currentUser = nil
        self.isAuthenticated = false
    }
    
    func getToken() throws -> String {
        return "mock-token"
    }
}
