//
//  Wrapper.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 10/07/23.
//

import Foundation

struct APIResponse: Decodable {
    let total: Int
    let totalPages: Int
    let results: [Photo]
}
