import Foundation

/// Model representing links associated with a user
struct UserLinks: Codable {
    
    // MARK: - Types
    enum CodingKeys: String, CodingKey {
        case selfLink = "self"
        case html
        case photos
        case likes
        case portfolio
        case following
        case followers
    }
    
    // MARK: - Properties
    let selfLink: String
    let html: String
    let photos: String
    let likes: String
    let portfolio: String?
    let following: String?
    let followers: String?
} 