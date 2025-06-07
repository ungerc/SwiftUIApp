import Testing
@testable import Authentication

@Suite("AuthViewModel Tests")
@MainActor
struct AuthViewModelTests {
    let sut: AuthViewModel
    let mockAuthService: MockAuthService
    
    init() {
        mockAuthService = MockAuthService()
        sut = AuthViewModel(authService: mockAuthService)
    }
    
    // MARK: - Sign In Tests
    
    @Test("Sign in success updates state correctly")
    func signInSuccess() async {
        // Given
        let email = "test@example.com"
        let password = "password123"
        mockAuthService.signInResult = .success(AuthUser(id: "1", email: email, name: "Test"))
        
        // When
        await sut.signIn(email: email, password: password)
        
        // Then
        #expect(!sut.isLoading)
        #expect(sut.errorMessage == nil)
        #expect(sut.isAuthenticated)
        #expect(sut.currentUser != nil)
    }
    
    @Test("Sign in failure sets error message")
    func signInFailure() async {
        // Given
        let email = "test@example.com"
        let password = "wrong"
        mockAuthService.signInResult = .failure(AuthError.signInFailed)
        
        // When
        await sut.signIn(email: email, password: password)
        
        // Then
        #expect(!sut.isLoading)
        #expect(sut.errorMessage != nil)
        #expect(sut.errorMessage == "Failed to sign in. Please check your credentials.")
        #expect(!sut.isAuthenticated)
    }
    
    @Test("Sign in shows loading state")
    func signInShowsLoadingState() async {
        // Given
        let email = "test@example.com"
        let password = "password123"
        mockAuthService.delay = 0.1 // Add small delay to test loading state
        
        // When
        let task = Task {
            await sut.signIn(email: email, password: password)
        }
        
        // Then - Check loading state immediately
        #expect(sut.isLoading)
        
        await task.value
        #expect(!sut.isLoading)
    }
    
    // MARK: - Sign Up Tests
    
    @Test("Sign up success updates state correctly")
    func signUpSuccess() async {
        // Given
        let name = "New User"
        let email = "new@example.com"
        let password = "password123"
        mockAuthService.signUpResult = .success(AuthUser(id: "2", email: email, name: name))
        
        // When
        await sut.signUp(name: name, email: email, password: password)
        
        // Then
        #expect(!sut.isLoading)
        #expect(sut.errorMessage == nil)
        #expect(sut.isAuthenticated)
    }
    
    @Test("Sign up failure sets error message")
    func signUpFailure() async {
        // Given
        let name = "New User"
        let email = "existing@example.com"
        let password = "password123"
        mockAuthService.signUpResult = .failure(AuthError.signUpFailed)
        
        // When
        await sut.signUp(name: name, email: email, password: password)
        
        // Then
        #expect(!sut.isLoading)
        #expect(sut.errorMessage != nil)
        #expect(sut.errorMessage == "Failed to create account. Please try again.")
    }
    
    // MARK: - Sign Out Tests
    
    @Test("Sign out success clears user")
    func signOutSuccess() async {
        // Given - Sign in first
        mockAuthService.signInResult = .success(AuthUser(id: "1", email: "test@example.com", name: "Test"))
        await sut.signIn(email: "test@example.com", password: "password")
        
        // When
        sut.signOut()
        
        // Then
        #expect(!sut.isAuthenticated)
        #expect(sut.currentUser == nil)
    }
    
    @Test("Sign out failure sets error message")
    func signOutFailure() async {
        // Given
        mockAuthService.signOutShouldThrow = true
        
        // When
        sut.signOut()
        
        // Then
        #expect(sut.errorMessage != nil)
        #expect(sut.errorMessage == "Failed to sign out.")
    }
}

// MARK: - Mock Auth Service

@MainActor
class MockAuthService: AuthServiceProtocol {
    var isAuthenticated: Bool = false
    var currentUser: AuthUser?
    var signInResult: Result<AuthUser, Error>?
    var signUpResult: Result<AuthUser, Error>?
    var signOutShouldThrow = false
    var delay: TimeInterval = 0
    
    func signIn(with credentials: AuthCredentials) async throws -> AuthUser {
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        
        guard let result = signInResult else {
            throw AuthError.signInFailed
        }
        
        switch result {
        case .success(let user):
            currentUser = user
            isAuthenticated = true
            return user
        case .failure(let error):
            throw error
        }
    }
    
    func signUp(with credentials: AuthCredentials, name: String) async throws -> AuthUser {
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        
        guard let result = signUpResult else {
            throw AuthError.signUpFailed
        }
        
        switch result {
        case .success(let user):
            currentUser = user
            isAuthenticated = true
            return user
        case .failure(let error):
            throw error
        }
    }
    
    func signOut() throws {
        if signOutShouldThrow {
            throw AuthError.signOutFailed
        }
        currentUser = nil
        isAuthenticated = false
    }
    
    func getToken() throws -> String {
        guard isAuthenticated else {
            throw AuthError.notAuthenticated
        }
        return "mock-token"
    }
}
