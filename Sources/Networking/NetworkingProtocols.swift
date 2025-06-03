import Foundation

public protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(from urlString: String) async throws -> T
    func post<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U
    func put<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U
    func delete(from urlString: String) async throws
}
