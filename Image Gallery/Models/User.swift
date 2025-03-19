import Foundation

/// Model representing a user on Unsplash
struct User: Codable {
    
    // MARK: - Types
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case name
        case portfolioUrl = "portfolio_url"
        case bio
        case location
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case totalCollections = "total_collections"
        case profileImage = "profile_image"
        case links
    }
    
    // MARK: - Properties
    let id: String
    let username: String
    let name: String
    let portfolioUrl: String?
    let bio: String?
    let location: String?
    let totalLikes: Int
    let totalPhotos: Int
    let totalCollections: Int
    let profileImage: ProfileImage
    let links: UserLinks
} 