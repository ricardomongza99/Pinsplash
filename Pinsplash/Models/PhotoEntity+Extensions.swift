//
//  PhotoEntity+Extensions.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 02/07/23.
//

import Foundation
import CoreData

extension PhotoEntity {
    func fromPhoto(photo: Photo) {
        self.id = photo.id
        self.width = Int16(photo.width)
        self.height = Int16(photo.height)
        self.photoDescription = photo.description
        self.likes = Int16(photo.likes)
        self.url = photo.urls.small
    }
}
