import Foundation
import SwiftUI

@Observable
@MainActor
class AuthViewModel {
    private let authManager: AuthManager
    
    init(authManager: AuthManager) {
        self.authManager = authManager
        // Initialize with values from authManager
        self.isAuthenticated = authManager.isAuthenticated
        self.currentUser = authManager.currentUser
    }
    
    var isAuthenticated: Bool = false
    var currentUser: User?
    var errorMessage: String?
    var isLoading: Bool = false
    
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let credentials = AuthCredentials(email: email, password: password)
            let user = try await authManager.signIn(with: credentials)
            
            currentUser = user
            isAuthenticated = true
            isLoading = false
        } catch {
            errorMessage = "Failed to sign in. Please check your credentials."
            isLoading = false
        }
    }
    
    func signUp(name: String, email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let credentials = AuthCredentials(email: email, password: password)
            let user = try await authManager.signUp(with: credentials, name: name)
            
            currentUser = user
            isAuthenticated = true
            isLoading = false
        } catch {
            errorMessage = "Failed to create account. Please try again."
            isLoading = false
        }
    }
    
    func signOut() {
        do {
            try authManager.signOut()
            self.isAuthenticated = false
            self.currentUser = nil
        } catch {
            self.errorMessage = "Failed to sign out."
        }
    }
}
import Foundation
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    private let authManager: AuthManager
    
    init(authManager: AuthManager) {
        self.authManager = authManager
        // Initialize with values from authManager
        self.isAuthenticated = authManager.isAuthenticated
        self.currentUser = authManager.currentUser
    }
    
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let credentials = AuthCredentials(email: email, password: password)
            let user = try await authManager.signIn(with: credentials)
            
            currentUser = user
            isAuthenticated = true
            isLoading = false
        } catch {
            errorMessage = "Failed to sign in. Please check your credentials."
            isLoading = false
        }
    }
    
    func signUp(name: String, email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let credentials = AuthCredentials(email: email, password: password)
            let user = try await authManager.signUp(with: credentials, name: name)
            
            currentUser = user
            isAuthenticated = true
            isLoading = false
        } catch {
            errorMessage = "Failed to create account. Please try again."
            isLoading = false
        }
    }
    
    func signOut() {
        do {
            try authManager.signOut()
            self.isAuthenticated = false
            self.currentUser = nil
        } catch {
            self.errorMessage = "Failed to sign out."
        }
    }
}
