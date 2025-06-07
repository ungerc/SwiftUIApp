import Testing
import Foundation
@testable import Authentication

@Suite("AuthViewModel Tests")
@MainActor
struct AuthViewModelTests {
    let mockAuthService = MockAuthService()
    var viewModel: AuthViewModel {
        AuthViewModel(authService: mockAuthService)
    }
    
    // MARK: - Sign In Tests
    
    @Test("Sign in successfully")
    func signInSuccess() async {
        // Given
        mockAuthService.signInResult = .success(AuthUser(id: "1", email: "test@example.com", name: "Test User"))
        let vm = viewModel
        
        // When
        await vm.signIn(email: "test@example.com", password: "password123")
        
        // Then
        #expect(!vm.isLoading)
        #expect(vm.errorMessage == nil)
        #expect(vm.isAuthenticated)
    }
    
    @Test("Sign in with invalid credentials")
    func signInFailure() async {
        // Given
        mockAuthService.signInResult = .failure(AuthError.signInFailed)
        let vm = viewModel
        
        // When
        await vm.signIn(email: "test@example.com", password: "wrongpassword")
        
        // Then
        #expect(!vm.isLoading)
        #expect(vm.errorMessage == "Failed to sign in. Please check your credentials.")
        #expect(!vm.isAuthenticated)
    }
    
    @Test("Sign in sets loading state")
    func signInSetsLoadingState() async {
        // Given
        mockAuthService.signInDelay = 0.1
        let vm = viewModel
        
        // When
        let signInTask = Task {
            await vm.signIn(email: "test@example.com", password: "password123")
        }
        
        // Then - Check loading state is set immediately
        try? await Task.sleep(nanoseconds: 10_000_000) // 0.01 seconds
        #expect(vm.isLoading)
        
        await signInTask.value
        #expect(!vm.isLoading)
    }
    
    // MARK: - Sign Up Tests
    
    @Test("Sign up new user")
    func signUpSuccess() async {
        // Given
        mockAuthService.signUpResult = .success(AuthUser(id: "1", email: "new@example.com", name: "New User"))
        let vm = viewModel
        
        // When
        await vm.signUp(name: "New User", email: "new@example.com", password: "password123")
        
        // Then
        #expect(!vm.isLoading)
        #expect(vm.errorMessage == nil)
        #expect(vm.isAuthenticated)
    }
    
    @Test("Sign up fails with error")
    func signUpFailure() async {
        // Given
        mockAuthService.signUpResult = .failure(AuthError.signUpFailed)
        let vm = viewModel
        
        // When
        await vm.signUp(name: "New User", email: "new@example.com", password: "password123")
        
        // Then
        #expect(!vm.isLoading)
        #expect(vm.errorMessage == "Failed to create account. Please try again.")
        #expect(!vm.isAuthenticated)
    }
    
    // MARK: - Sign Out Tests
    
    @Test("Sign out successfully")
    func signOutSuccess() {
        // Given
        mockAuthService.isAuthenticated = true
        let vm = viewModel
        
        // When
        vm.signOut()
        
        // Then
        #expect(vm.errorMessage == nil)
        #expect(!mockAuthService.isAuthenticated)
    }
    
    @Test("Sign out fails with error")
    func signOutFailure() {
        // Given
        mockAuthService.signOutShouldThrow = true
        let vm = viewModel
        
        // When
        vm.signOut()
        
        // Then
        #expect(vm.errorMessage == "Failed to sign out.")
    }
}

// MARK: - Mock Auth Service

class MockAuthService: AuthServiceProtocol {
    nonisolated var isAuthenticated = false
    nonisolated var currentUser: AuthUser?
    var signInResult: Result<AuthUser, Error> = .success(AuthUser(id: "1", email: "test@example.com", name: "Test User"))
    var signUpResult: Result<AuthUser, Error> = .success(AuthUser(id: "1", email: "test@example.com", name: "Test User"))
    var signOutShouldThrow = false
    var signInDelay: TimeInterval = 0
    
    @MainActor
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
    
    @MainActor
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
    
    nonisolated func signOut() throws {
        if signOutShouldThrow {
            throw AuthError.signOutFailed
        }
        self.currentUser = nil
        self.isAuthenticated = false
    }
    
    nonisolated func getToken() throws -> String {
        return "mock-token"
    }
}
