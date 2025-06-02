import Foundation
import Authentication
import Combine

class AuthViewModel: ObservableObject {
    private let authManager: AuthManager
    
    init(authManager: AuthManager) {
        self.authManager = authManager
    }
    
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    init() {
        // In a real app, you might check for a stored token here
        // and try to restore the session
        self.isAuthenticated = authManager.isAuthenticated
        self.currentUser = authManager.currentUser
    }
    
    func signIn(email: String, password: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            let credentials = AuthCredentials(email: email, password: password)
            let user = try await authManager.signIn(with: credentials)
            
            DispatchQueue.main.async {
                self.currentUser = user
                self.isAuthenticated = true
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to sign in. Please check your credentials."
                self.isLoading = false
            }
        }
    }
    
    func signUp(name: String, email: String, password: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            let credentials = AuthCredentials(email: email, password: password)
            let user = try await authManager.signUp(with: credentials, name: name)
            
            DispatchQueue.main.async {
                self.currentUser = user
                self.isAuthenticated = true
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to create account. Please try again."
                self.isLoading = false
            }
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
