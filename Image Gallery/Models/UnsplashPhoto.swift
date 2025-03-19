import Foundation

/// Model representing a photo from Unsplash
struct UnsplashPhoto: Codable, Identifiable {
    
    // MARK: - Types
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case color
        case description
        case altDescription = "alt_description"
        case urls
        case links
        case likes
        case user
    }
    
    // MARK: - Properties
    let id: String
    let width: Int
    let height: Int
    let color: String
    let description: String?
    let altDescription: String?
    let urls: PhotoURLs
    let links: PhotoLinks
    let likes: Int
    let user: User
} 