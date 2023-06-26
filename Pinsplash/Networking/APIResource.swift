//
//  APIResource.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 25/06/23.
//
// Special thanks to matteomanferdini for this implementation
// https://matteomanferdini.com/network-requests-rest-apis-ios-swift/
//

import Foundation

protocol APIResource {
    associatedtype ModelType: Decodable
    var methodPath: String { get }
    var parameters: [String: String] { get }
}

extension APIResource {
    var url: URL {
        var components = URLComponents(string: "https://api.unsplash.com/photos")!
        components.path = methodPath
        components.queryItems = parameters.map{ URLQueryItem(name: $0.key, value: $0.value) }
        return components.url!
    }
}


struct PhotosResource: APIResource {
    typealias ModelType = [Photo]
    
    var methodPath: String {
        return "/photos"
    }
    
    var parameters: [String : String] {
        return ["per_page": "30"]
    }
}
