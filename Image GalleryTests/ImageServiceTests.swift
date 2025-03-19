import XCTest
@testable import Image_Gallery

final class ImageServiceTests: XCTestCase {
    var sut: ImageService!
    var mockNetworkService: MockNetworkService!
    var mockSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockSession = MockURLSession()
        sut = ImageService(networkService: mockNetworkService, session: mockSession)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        mockSession = nil
        super.tearDown()
    }
    
    func testFetchPhotosSuccess() async throws {
        // Given
        let mockPhotos = [
            UnsplashPhoto(id: "1", width: 100, height: 100, color: "#000000",
                         description: nil, altDescription: nil,
                         urls: PhotoURLs(raw: "raw", full: "full", regular: "regular",
                                       small: "small", thumb: "thumb"),
                         links: PhotoLinks(selfLink: "self", html: "html",
                                         download: "download", downloadLocation: "location"),
                         likes: 0,
                         user: createMockUser())
        ]
        mockNetworkService.mockResult = mockPhotos
        
        // When
        let result = try await sut.fetchPhotos(page: 1, perPage: 10)
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, "1")
    }
    
    func testFetchPhotosWithCategory() async throws {
        // Given
        let mockPhotos = [
            UnsplashPhoto(id: "1", width: 100, height: 100, color: "#000000",
                         description: nil, altDescription: nil,
                         urls: PhotoURLs(raw: "raw", full: "full", regular: "regular",
                                       small: "small", thumb: "thumb"),
                         links: PhotoLinks(selfLink: "self", html: "html",
                                         download: "download", downloadLocation: "location"),
                         likes: 0,
                         user: createMockUser())
        ]
        mockNetworkService.mockResult = mockPhotos
        
        // When
        let result = try await sut.fetchPhotos(page: 1, perPage: 10, category: .nature)
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, "1")
        
        // Verify the endpoint was created with the correct category
        if case let .fetchPhotos(page, perPage, category) = mockNetworkService.lastEndpoint {
            XCTAssertEqual(page, 1)
            XCTAssertEqual(perPage, 10)
            XCTAssertEqual(category, .nature)
        } else {
            XCTFail("Expected fetchPhotos endpoint")
        }
    }
    
    func testFetchPhotosFailure() async {
        // Given
        mockNetworkService.mockError = NetworkError.serverError(statusCode: 500)
        
        // When/Then
        do {
            _ = try await sut.fetchPhotos(page: 1, perPage: 10)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
    
    func testDownloadImageSuccess() async throws {
        // Given
        let url = URL(string: "https://example.com/image.jpg")!
        let mockImage = UIImage()
        let mockData = mockImage.pngData()!
        let mockResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockSession.mockData = mockData
        mockSession.mockResponse = mockResponse
        
        // When
        let downloadedImage = try await sut.downloadImage(from: url)
        
        // Then
        XCTAssertNotNil(downloadedImage)
        XCTAssertEqual(mockSession.lastURL, url)
    }
    
    func testDownloadImageFailure() async {
        // Given
        let url = URL(string: "https://invalid-url.com/image.jpg")!
        let mockResponse = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
        mockSession.mockData = nil
        mockSession.mockResponse = mockResponse
        
        // When/Then
        do {
            _ = try await sut.downloadImage(from: url)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
    
    func testDownloadImageInvalidData() async {
        // Given
        let url = URL(string: "https://example.com/image.jpg")!
        let mockResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockSession.mockData = Data([0, 1, 2, 3]) // Invalid image data
        mockSession.mockResponse = mockResponse
        
        // When/Then
        do {
            _ = try await sut.downloadImage(from: url)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is ImageDownloadError)
        }
    }
    
    private func createMockUser() -> User {
        User(id: "1", username: "test", name: "Test User",
             portfolioUrl: nil, bio: nil, location: nil,
             totalLikes: 0, totalPhotos: 0, totalCollections: 0,
             profileImage: ProfileImage(small: "small", medium: "medium", large: "large"),
             links: UserLinks(selfLink: "self", html: "html", photos: "photos",
                            likes: "likes", portfolio: nil, following: nil,
                            followers: nil))
    }
}

// MARK: - Mock Classes
final class MockNetworkService: NetworkServiceProtocol {
    var mockResult: Any?
    var mockError: Error?
    var lastEndpoint: Endpoint?
    
    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        lastEndpoint = endpoint
        
        if let error = mockError {
            throw error
        }
        
        guard let result = mockResult as? T else {
            throw NetworkError.decodingError(NSError(domain: "", code: -1))
        }
        
        return result
    }
}

final class MockURLSession: URLSession {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    var lastURL: URL?
    
    override func data(from url: URL) async throws -> (Data, URLResponse) {
        lastURL = url
        
        if let error = mockError {
            throw error
        }
        
        guard let data = mockData,
              let response = mockResponse else {
            throw NetworkError.invalidResponse
        }
        
        return (data, response)
    }
} 