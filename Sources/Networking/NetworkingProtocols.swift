import Foundation

/// Protocol defining the interface for network services.
/// This abstraction allows for different network implementations and makes testing easier.
public protocol NetworkServiceProtocol {
    /// Fetches data from a URL and decodes it into the specified type.
    /// - Parameter urlString: The URL to fetch data from
    /// - Returns: The decoded data of type `T`
    /// - Throws: `NetworkError.invalidURL` if the URL is invalid,
    ///          `NetworkError.invalidResponse` for non-2xx status codes,
    ///          `NetworkError.decodingFailed` if decoding fails,
    ///          `NetworkError.requestFailed` for other network errors
    func fetch<T: Decodable>(from urlString: String) async throws -> T
    
    /// Sends a POST request with an encodable body and returns a decoded response.
    /// - Parameters:
    ///   - urlString: The URL to send the request to
    ///   - body: The encodable data to send in the request body
    /// - Returns: The decoded response of type `U`
    /// - Throws: `NetworkError.invalidURL` if the URL is invalid,
    ///          `NetworkError.invalidResponse` for non-2xx status codes,
    ///          `NetworkError.decodingFailed` if decoding fails,
    ///          `NetworkError.requestFailed` for other network errors
    func post<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U
    
    /// Sends a PUT request with an encodable body and returns a decoded response.
    /// - Parameters:
    ///   - urlString: The URL to send the request to
    ///   - body: The encodable data to send in the request body
    /// - Returns: The decoded response of type `U`
    /// - Throws: `NetworkError.invalidURL` if the URL is invalid,
    ///          `NetworkError.invalidResponse` for non-2xx status codes,
    ///          `NetworkError.decodingFailed` if decoding fails,
    ///          `NetworkError.requestFailed` for other network errors
    func put<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U
    
    /// Sends a DELETE request to the specified URL.
    /// - Parameter urlString: The URL to send the delete request to
    /// - Throws: `NetworkError.invalidURL` if the URL is invalid,
    ///          `NetworkError.invalidResponse` for non-2xx status codes,
    ///          `NetworkError.requestFailed` for other network errors
    func delete(from urlString: String) async throws
}
