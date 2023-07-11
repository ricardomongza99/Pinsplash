//
//  PhotoResource.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 10/07/23.
//

import Foundation

struct PhotosResource: APIResource {
    typealias ModelType = [Photo]
    
    let page: Int
    let perPage: Int
    
    var endpoint: String {
        return "/photos"
    }

    var parameters: [String : String] {
        return ["page": String(page), "per_page": String(perPage)]
    }
}
