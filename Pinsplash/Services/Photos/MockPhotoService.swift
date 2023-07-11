//
//  MockPhotoService.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 10/07/23.
//

import Foundation

class MockPhotoService: PhotoFetching {
    
    // MARK: - PROPERTIES
    
    var isLoading: Bool = false
    
    private let photosPerPage = 20
    private var currentPage = 1
    private var totalPages = 1
    
    // MARK: - FETCH METHODS
    
    func fetchPhotos(query: String?, completion: @escaping ([Photo]?) -> Void) {
        guard currentPage <= 4 else {
            completion(nil)
            return
        }
        
        let mockPhotos = TestData.getPhotos(page: currentPage)
        
        print("✅ Mock photos fetched. Current page: \(currentPage)")
        currentPage += 1
        isLoading = false
        completion(mockPhotos)
    }
}
