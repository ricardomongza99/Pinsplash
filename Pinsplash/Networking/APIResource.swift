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
    var filter: String? { get }
}

extension APIResource {
    var url: URL {
        var components = URLComponents(string: "https://api.unsplash.com/photos")!
        components.path = methodPath
        if let filter = filter {
            components.queryItems?.append(URLQueryItem(name: "filter", value: filter))
        }
        return components.url!
    }
}


struct PhotosResource: APIResource {
    typealias ModelType = [Photo]
    var id: Int?
    
    var methodPath: String {
        if let id = id {
            return "/photos/:\(id)"
        }
        return "/photos"
    }
    
    var filter: String?
}
