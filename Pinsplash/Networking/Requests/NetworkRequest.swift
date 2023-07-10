//
//  NetworkRequest.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 25/06/23.
//
// Special thanks to matteomanferdini for this implementation
// https://matteomanferdini.com/network-requests-rest-apis-ios-swift/
//

import Foundation
import UIKit

protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) -> ModelType?
    func execute(withCompletion completion: @escaping (ModelType?) -> Void)
}

extension NetworkRequest {
    func load(_ url: URL, withCompletion completion: @escaping (ModelType?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Client-ID RXx8DV_H7CsbVPxG_ohHkSkU4_dZaGv5s2PzZIROFfM", forHTTPHeaderField: "Authorization")
                
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if let error = error {
                print("Error with http call: \(error)")
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Error with the resposne, unexpected status code")
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            if let data = data, let value = self.decode(data) {
                DispatchQueue.main.async { completion(value) }
            }
        }
        task.resume()
    }
}
