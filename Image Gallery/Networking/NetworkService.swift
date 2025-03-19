import Foundation

// MARK: - Protocols
/// Protocol defining the network service interface
protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

// MARK: - Implementation
/// Implementation of NetworkServiceProtocol
final class NetworkService: NetworkServiceProtocol {
    // MARK: - Properties
    private let session: URLSession
    private let decoder: JSONDecoder
    
    // MARK: - Initialization
    init(session: URLSession = .shared,
         decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    // MARK: - Public Methods
    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

// MARK: - Errors
/// Network errors that can occur during API calls
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingError(Error)
} 