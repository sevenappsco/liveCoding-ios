import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: [String: Any]? { get }
    var queryItems: [URLQueryItem]? { get }
}

extension Endpoint {
    
    var url: URL? {
        var components = URLComponents(string: baseURL)
        components?.path = path
        components?.queryItems = queryItems
        return components?.url
    }
    
    var headers: [String: String] {
        [:]
    }
    
    var body: [String: Any]? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum UnsplashEndpoint: Endpoint {
    case fetchPhotos(page: Int, perPage: Int, category: UnsplashCategory?)
    case downloadPhoto(id: String)
    
    var baseURL: String {
        switch self {
        case .fetchPhotos:
            return "https://api.unsplash.com"
            
        case .downloadPhoto:
            return "https://images.unsplash.com"
        }
    }
    
    var path: String {
        switch self {
        case .fetchPhotos(_, _, let category):
            if category != nil {
                return "/search/photos"
            }
            
            return "/photos"
            
        case .downloadPhoto(let id):
            return "/\(id)"
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String: String] {
        var headers = ["Accept-Version": "v1"]
        headers["Authorization"] = "Client-ID \(APIConfig.Unsplash.accessKey)"
        
        return headers
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchPhotos(let page, let perPage, let category):
            var items = [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "per_page", value: String(perPage))
            ]
            
            if let category = category {
                items.append(URLQueryItem(name: "query", value: category.rawValue))
            }
            return items
            
        case .downloadPhoto:
            return [URLQueryItem(name: "auto", value: "format")]
        }
    }
} 
