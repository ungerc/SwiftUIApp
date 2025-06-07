import Testing
@testable import Networking

@Suite("NetworkManager Tests")
struct NetworkManagerTests {
    let sut = NetworkManager()
    
    // MARK: - Fetch Tests
    
    @Test("Fetch with invalid URL throws invalid URL error")
    func fetchWithInvalidURL() async throws {
        // Given
        let invalidURL = "not a valid url"
        
        // When/Then
        await #expect(throws: NetworkError.self) {
            let _: TestDecodable = try await sut.fetch(from: invalidURL)
        }
    }
    
    // MARK: - POST Tests
    
    @Test("Post with invalid URL throws invalid URL error")
    func postWithInvalidURL() async throws {
        // Given
        let invalidURL = "not a valid url"
        let body = TestEncodable(value: "test")
        
        // When/Then
        await #expect(throws: NetworkError.self) {
            let _: TestDecodable = try await sut.post(to: invalidURL, body: body)
        }
    }
    
    // MARK: - PUT Tests
    
    @Test("Put with invalid URL throws invalid URL error")
    func putWithInvalidURL() async throws {
        // Given
        let invalidURL = "not a valid url"
        let body = TestEncodable(value: "test")
        
        // When/Then
        await #expect(throws: NetworkError.self) {
            let _: TestDecodable = try await sut.put(to: invalidURL, body: body)
        }
    }
    
    // MARK: - DELETE Tests
    
    @Test("Delete with invalid URL throws invalid URL error")
    func deleteWithInvalidURL() async throws {
        // Given
        let invalidURL = "not a valid url"
        
        // When/Then
        await #expect(throws: NetworkError.self) {
            try await sut.delete(from: invalidURL)
        }
    }
}

// MARK: - Test Models

struct TestEncodable: Encodable {
    let value: String
}

struct TestDecodable: Decodable {
    let result: String
}
