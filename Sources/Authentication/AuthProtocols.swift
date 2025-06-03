import Foundation

public protocol AuthServiceProtocol {
    var isAuthenticated: Bool { get }
    var currentUser: AuthUser? { get }
    
    func signIn(with credentials: AuthCredentials) async throws -> AuthUser
    func signUp(with credentials: AuthCredentials, name: String) async throws -> AuthUser
    func signOut() throws
    func getToken() throws -> String
}
