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
    
    func fetchPhotos(completion: @escaping([Photo]?) -> Void ){
        let resource = PhotosResource(page: currentPage, perPage: photosPerPage)
        let request = APIRequest(resource: resource)
        
        request.execute { [weak self] photos in
            completion(photos)
            
            if photos != nil {
                self?.currentPage += 1
            } else {
                print("Couldn't fetch photos")
            }
        }
    }
    
    func resetPagination() {
        currentPage = 0
    }
}
