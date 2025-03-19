//
//  GalleryViewController.swift
//  Image Gallery
//
//  Created by Emirhan Erdogan on 13/01/2025.
//

import UIKit

class GalleryViewController: UIViewController {
    
    // MARK: - Properties
    private let imageService = ImageService()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchImages()
    }
    
    // MARK: - Methods
    private func fetchImages() {
        Task {
            do {
                let photos = try await imageService.fetchPhotos(page: 1, perPage: 20, category: .animals)
                let imageData = try await imageService.downloadImage(from: photos.first!.urls.thumb)
                let image = UIImage(data: imageData)
            } catch {
                print(error)
            }
        }
    }
}
