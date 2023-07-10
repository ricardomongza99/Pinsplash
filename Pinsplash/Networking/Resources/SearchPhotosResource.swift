//
//  SearchPhotosResource.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 10/07/23.
//

import Foundation

struct SearchPhotosResource: APIResource {
    typealias ModelType = APIResponse
    
    let page: Int
    let perPage: Int
    let query: String
    
    var endpoint: String {
        return "/search/photos"
    }
    
    var parameters: [String : String] {
        return ["page": String(page), "per_page": String(perPage), "query": query]
    }
}
