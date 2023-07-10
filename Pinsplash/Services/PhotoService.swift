//
//  PhotoService.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 26/06/23.
//

import Foundation

class PhotoService {
    
    // MARK: - PROPERTIES
    
    var useMockData: Bool
    var isLoading = false
    
    private let photosPerPage = 20
    private var currentPage = 1
    private var totalPages = 1


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
    
    func fetchPhotos(query: String, completion: @escaping([Photo]?) -> Void) {
        guard !isLoading, currentPage <= totalPages else { return }
        
        isLoading = true
        
        let resource = SearchPhotosResource(page: currentPage, perPage: photosPerPage, query: query)
        let request = APIRequest(resource: resource)
        
        request.execute { [weak self] response in
            
            if let response = response {
                print("✅ Photos fetched. Current page: \(self?.currentPage ?? 0)")
                self?.currentPage += 1
                self?.totalPages = response.totalPages
                completion(response.results)
            } else {
                print("Couldn't fetch photos")
                completion(nil)
            }
            self?.isLoading = false
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
        guard currentPage <= 4 else {
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
