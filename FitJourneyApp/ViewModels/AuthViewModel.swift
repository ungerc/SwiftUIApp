import Foundation
import SwiftUI
import AppCore

@Observable
@MainActor
class AuthViewModel {
    private let authAdapter: AuthAdapter
    
    init(authAdapter: AuthAdapter) {
        self.authAdapter = authAdapter
        // Initialize with values from authAdapter
        self.needsAuthentication = !authAdapter.isAuthenticated
        self.currentUser = authAdapter.currentUser
    }
    
    var needsAuthentication: Bool = true
    var currentUser: User?
    var errorMessage: String?
    var isLoading: Bool = false
    
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await authAdapter.signIn(email: email, password: password)
            
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
            let user = try await authAdapter.signUp(name: name, email: email, password: password)
            
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
            try authAdapter.signOut()
            self.needsAuthentication = true
            self.currentUser = nil
        } catch {
            self.errorMessage = "Failed to sign out."
        }
    }
}
