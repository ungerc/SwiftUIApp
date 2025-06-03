import Foundation
import SwiftUI

@Observable
@MainActor
class AuthViewModel {
    private let authManager: AuthManager
    
    init(authManager: AuthManager) {
        self.authManager = authManager
        // Initialize with values from authManager
        self.needsAuthentication = !authManager.isAuthenticated
        self.currentUser = authManager.currentUser
    }
    
    var needsAuthentication: Bool = true
    var currentUser: User?
    var errorMessage: String?
    var isLoading: Bool = false
    
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let credentials = AuthCredentials(email: email,
                                              password: password)
            let user = try await authManager.signIn(with: credentials)
            
            currentUser = user
            needsAuthentication = false
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
            needsAuthentication = false
            isLoading = false
        } catch {
            errorMessage = "Failed to create account. Please try again."
            isLoading = false
        }
    }
    
    func signOut() {
        do {
            try authManager.signOut()
            self.needsAuthentication = true
            self.currentUser = nil
        } catch {
            self.errorMessage = "Failed to sign out."
        }
    }
}
