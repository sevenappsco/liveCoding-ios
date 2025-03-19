import Foundation
import UIKit

protocol ImageServiceProtocol {
    func fetchPhotos(page: Int, perPage: Int, category: UnsplashCategory?) async throws -> [UnsplashPhoto]
    func downloadImage(from url: URL) async throws -> Data
}

final class ImageService: ImageServiceProtocol {
    
    // MARK: - Properties
    private let networkService: NetworkServiceProtocol
    private let session: URLSession
    
    // MARK: - Life Cycle
    init(networkService: NetworkServiceProtocol = NetworkService(),
         session: URLSession = .shared) {
        self.networkService = networkService
        self.session = session
    }
    
    // MARK: - Methods
    func fetchPhotos(page: Int, perPage: Int, category: UnsplashCategory? = nil) async throws -> [UnsplashPhoto] {
        let endpoint = UnsplashEndpoint.fetchPhotos(page: page, perPage: perPage, category: category)
        
        if category != nil {
            let searchResponse: SearchResponse = try await networkService.fetch(endpoint)
            return searchResponse.results
        } else {
            return try await networkService.fetch(endpoint)
        }
    }
    
    func downloadImage(from url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 500)
        }
        
        return data
    }
} 
