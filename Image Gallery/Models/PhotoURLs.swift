import Foundation

/// Model representing different URL sizes for a photo
struct PhotoURLs: Codable {
    
    // MARK: - Properties
    let raw: URL
    let full: URL
    let regular: URL
    let small: URL
    let thumb: URL
} 