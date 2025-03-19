import Foundation

/// Model representing a search response from Unsplash
struct SearchResponse: Codable {
    
    // MARK: - Types
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
    
    // MARK: - Properties
    let total: Int
    let totalPages: Int
    let results: [UnsplashPhoto]
} 