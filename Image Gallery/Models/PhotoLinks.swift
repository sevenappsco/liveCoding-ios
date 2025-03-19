import Foundation

/// Model representing links associated with a photo
struct PhotoLinks: Codable {
    
    // MARK: - Types
    enum CodingKeys: String, CodingKey {
        case selfLink = "self"
        case html
        case download
        case downloadLocation = "download_location"
    }
    
    // MARK: - Properties
    let selfLink: String
    let html: String
    let download: String
    let downloadLocation: String
} 