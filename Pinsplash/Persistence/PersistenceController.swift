//
//  PersistenceController.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 02/07/23.
//

import Foundation
import CoreData

class PersistenceController {
    
    // MARK: - PROPERTIES
    
    let container: NSPersistentContainer
    
    // MARK: - INITIALIZERS
    
    init() {
        container = NSPersistentContainer(name: "Pinsplash")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error)")
            }
        }
    }
    
    // MARK: - PUBLIC METHODS
    
    func savePhoto(photo: Photo) {
        let photoEntity = PhotoEntity(context: container.viewContext)
        photoEntity.id = photo.id
        photoEntity.width = Int16(photo.width)
        photoEntity.height = Int16(photo.height)
        photoEntity.photoDescription = photo.description
        photoEntity.likes = Int16(photo.likes)
        photoEntity.url = photo.urls.small
        
        // Save the context
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                fatalError("Error saving context Core Data: \(error)")
            }
        }
    }
    
    func fetchPhotos() -> [Photo] {
        let fetchRequest: NSFetchRequest<PhotoEntity> = PhotoEntity.fetchRequest()
        do {
            let photoEntities = try container.viewContext.fetch(fetchRequest)
            let photos = photoEntities.map { photoEntity in
                return Photo(id: photoEntity.id ?? "",
                             width: Int(photoEntity.width),
                             height: Int(photoEntity.height ),
                             description: photoEntity.photoDescription ?? "",
                             likes: Int(photoEntity.likes),
                             urls: Photo.URLs(
                                raw: photoEntity.url ?? "",
                                full: photoEntity.url ?? "",
                                regular: photoEntity.url ?? "",
                                small: photoEntity.url ?? "",
                                thumb: photoEntity.url ?? "",
                                smallS3: photoEntity.url ?? ""),
                             user: User(id: "test", username: "test", name: "test", firstName: "test", lastName: nil, bio: nil, location: nil, totalLikes: 0, totalPhotos: 2, profileImage: User.URLs(small: "", medium: "", large: "")))
            }
            return photos
        } catch {
            fatalError("Error fetching photos from Core Data: \(error)")
        }
    }
}
