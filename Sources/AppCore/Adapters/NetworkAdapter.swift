import Foundation
import Networking

// This adapter exposes the NetworkServiceProtocol to other modules
// without them needing to import Networking directly
public class NetworkAdapter {
    private let networkService: NetworkServiceProtocol
    
    public init(networkService: NetworkServiceProtocol = NetworkManager()) {
        self.networkService = networkService
    }
    
    public func fetch<T: Decodable>(from urlString: String) async throws -> T {
        return try await networkService.fetch(from: urlString)
    }
    
    public func post<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U {
        return try await networkService.post(to: urlString, body: body)
    }
}
