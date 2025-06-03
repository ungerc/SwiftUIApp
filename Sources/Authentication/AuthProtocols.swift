import Foundation

public protocol AuthServiceProtocol {
    var isAuthenticated: Bool { get }
    var currentUser: User? { get }
    
    func signIn(with credentials: AuthCredentials) async throws -> User
    func signUp(with credentials: AuthCredentials, name: String) async throws -> User
    func signOut() throws
    func getToken() throws -> String
}
