//
//  PhotoService.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 26/06/23.
//

import Foundation

class PhotoService {
    private var currentPage = 0
    private let photosPerPage = 10
    var isLoading: Bool = false
    
    func fetchPhotos(completion: @escaping([Photo]?) -> Void){
        guard !isLoading else { return }
        
        isLoading = true
        let resource = PhotosResource(page: currentPage, perPage: photosPerPage)
        let request = APIRequest(resource: resource)
        
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
        currentPage = 0
    }
}
