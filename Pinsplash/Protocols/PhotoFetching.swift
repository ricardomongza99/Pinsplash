//
//  PhotoFetching.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 10/07/23.
//

import Foundation

protocol PhotoFetching {
    var isLoading: Bool { get }
    func fetchPhotos(query: String?, completion: @escaping ([Photo]?) -> Void)
}
