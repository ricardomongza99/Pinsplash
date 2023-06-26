//
//  TestData.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 25/06/23.
//

import Foundation


struct TestData {
    
    static var photos: [Photo] = {
        let url = Bundle.main.url(forResource: "page0", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let photos = try! decoder.decode([Photo].self, from: data)
        return photos
    }()
    
    static func getPhotos(page: Int) -> [Photo] {
        let url = Bundle.main.url(forResource: "page\(page)", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let photos = try! decoder.decode([Photo].self, from: data)
        return photos
    }
}
