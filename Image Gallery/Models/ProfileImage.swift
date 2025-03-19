import Foundation

/// Model representing different sizes of a user's profile image
struct ProfileImage: Codable {
    
    // MARK: - Properties
    let small: String
    let medium: String
    let large: String
} 