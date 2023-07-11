//
//  PhotoService.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 26/06/23.
//

import Foundation

class PhotoService: PhotoFetching {

    
    // MARK: - PROPERTIES
    
    var isLoading = false
    
    private let photosPerPage = 20
    private var currentPage = 1
    private var totalPages = 1
    
    
    // MARK: - FETCH METHODS
    
    func fetchPhotos(query: String?, completion: @escaping ([Photo]?) -> Void) {
        // TODO: Implement Type-Erased Wrappers for SearchPhotosResource and PhotosResource
        if let query = query {
            fetchPhotos(query: query, completion: completion)
        } else {
            fetchPhotos(completion: completion)
        }
    }
    
    
    private func fetchPhotos(query: String, completion: @escaping([Photo]?) -> Void) {
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
    
    private func fetchPhotos(completion: @escaping([Photo]?) -> Void) {
        guard !isLoading else { return }
        
        let resource = PhotosResource(page: currentPage, perPage: photosPerPage)
        let request = APIRequest(resource: resource)
        
        isLoading = true

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

    func resetPagination() {
        currentPage = 1
        totalPages = 1
    }
}
