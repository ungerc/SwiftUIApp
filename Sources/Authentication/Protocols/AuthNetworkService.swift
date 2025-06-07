import Foundation

/// Protocol for network services that can handle authentication-related requests.
/// This abstraction allows for easy mocking in tests and swapping implementations.
public protocol AuthNetworkService {
    /// Sends a POST request with an encodable body and expects a decodable response.
    /// - Parameters:
    ///   - urlString: The URL to send the request to
    ///   - body: The encodable data to send in the request body
    /// - Returns: The decoded response of type `U`
    /// - Throws: Network-related errors or decoding errors
    func post<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U
}
