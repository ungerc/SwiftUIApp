import Foundation
import AppCore

// This is a wrapper around the ApplicationNetworkAdapter
public class NetworkManager {
    private let networkAdapter: ApplicationNetworkAdapter
    
    init(networkAdapter: ApplicationNetworkAdapter) {
        self.networkAdapter = networkAdapter
    }
    
    public func fetch<T: Decodable>(from urlString: String) async throws -> T {
        return try await networkAdapter.fetch(from: urlString)
    }
    
    public func post<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U {
        return try await networkAdapter.post(to: urlString, body: body)
    }
    
    public func put<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U {
        return try await networkAdapter.put(to: urlString, body: body)
    }
    
    public func delete(from urlString: String) async throws {
        try await networkAdapter.delete(from: urlString)
    }
}

// Using the types from AppCore for any network-related errors
public typealias NetworkError = Error
