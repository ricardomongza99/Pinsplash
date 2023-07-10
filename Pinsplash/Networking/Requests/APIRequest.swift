//
//  APIRequest.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 10/07/23.
//

import Foundation

class APIRequest<Resource: APIResource> {
    let resource: Resource
    
    init(resource: Resource) {
        self.resource = resource
    }
}

extension APIRequest: NetworkRequest {
    func decode(_ data: Data) -> Resource.ModelType? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let items = try? decoder.decode(Resource.ModelType.self, from: data)
        return items
    }
    
    func execute(withCompletion completion: @escaping (Resource.ModelType?) -> Void) {
        print(resource.url)
        load(resource.url, withCompletion: completion)
    }
}
