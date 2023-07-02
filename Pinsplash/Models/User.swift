//
//  User.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 25/06/23.
//

import Foundation


struct User: Codable {
    let id: String
    let username: String
    let name: String
    let firstName: String
    let lastName: String?
    let bio: String?
    let location: String?
    let totalLikes: Int
    let totalPhotos: Int
    let profileImage: URLs
    
    struct URLs: Codable {
        let small: String
        let medium: String
        let large: String
    }
}
