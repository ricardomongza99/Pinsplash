//
//  PhotoService.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 26/06/23.
//

import Foundation

class PhotoService {
    
    // MARK: - PROPERTIES
    
    private var currentPage = 0
    private let photosPerPage = 20
    var useMockData: Bool
    var isLoading = false

    
    // MARK: - INITIALIZERS
    
    init(useMockData: Bool = false) {
        self.useMockData = useMockData
    }
    
    
    // MARK: - FETCH METHODS
    
    func fetchPhotos(completion: @escaping([Photo]?) -> Void){
        guard !isLoading else { return }
        
        isLoading = true
        
        if useMockData {
            fetchMockData(completion: completion)
        } else {
            fetchRealData(completion: completion)
        }
    }
    
    private func fetchRealData(completion: @escaping([Photo]?) -> Void) {
        let resource = PhotosResource(page: currentPage, perPage: photosPerPage)
        let request = APIRequest(resource: resource)
        
        print("Will fetch photos for page \(currentPage)")
        request.execute { [weak self] photos in
            completion(photos)
            
            if photos != nil {
                print("✅ Photos fetched. Current page: \(self?.currentPage ?? 0)")
                self?.currentPage += 1
            } else {
                print("Couldn't fetch photos")
            }
            self?.isLoading = false
        }
    }
    
    private func fetchMockData(completion: @escaping([Photo]?) -> Void) {
        guard currentPage <= 3 else {
            completion(nil)
            return
        }
        
        let mockPhotos = TestData.getPhotos(page: currentPage)
        print(mockPhotos.count)
        completion(mockPhotos)
        
        print("✅ Mock photos fetched. Current page: \(currentPage)")
        currentPage += 1
        isLoading = false
    }
    
    func resetPagination() {
        currentPage = 0
    }
}
