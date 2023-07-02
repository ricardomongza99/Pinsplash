//
//  Photo.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 25/06/23.
//

import Foundation


struct Photo: Codable {
    let id: String
    let width: Int
    let height: Int
    let description: String?
    let likes: Int
    let urls: URLs
    let user: User
    
    var size: CGSize {
        return CGSize(width: self.width, height: self.height)
    }
    
    var aspectRatio: CGFloat {
        return CGFloat(height) / CGFloat(width)
    }
}
