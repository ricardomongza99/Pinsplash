//
//  ImageCache.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 27/06/23.
//
// Special thanks to Maksym Shcheglov for the decoded image implementation
// https://medium.com/@mshcheglov/reusable-image-cache-in-swift-9b90eb338e8d
//

import UIKit

protocol ImageCacheType: AnyObject {
    /// Returns the image associated with a given url
    func image(for url: URL) -> UIImage?
    /// Inserts the image of the specified url in the cache
    func insertImage(_ image: UIImage?, for url: URL)
    /// Removes the image of the specified url in the cache
    func removeImage(for url: URL)
    /// Removes all images from the cache
    func removeAllImages()
    /// Accesses the value associated with the given key for reading and writing
    subscript(_ url: URL) -> UIImage? { get set }
}

// TODO: Syncronize access to cache

final class ImageCache {
    
    // MARK: - PROPERTIES
    
    /// 1st level cache: contains encoded images
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = config.countLimit
        return cache
    }()
    
    /// 2nd level cache: contains decoded images
    private lazy var decodedImageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = config.memoryLimit
        return cache
    }()
    
    private let config: Config
    
    struct Config {
        let countLimit: Int
        let memoryLimit: Int
        
        static let defaultConfig = Config(countLimit: 100, memoryLimit: 1024 * 1024 * 100) // 100MB
    }
    
    
    init(config: Config = Config.defaultConfig) {
        self.config = config
    }
}

extension ImageCache: ImageCacheType {
    func image(for url: URL) -> UIImage? {
        // best case scenario, returns decoded image
        if let decodedImage = decodedImageCache.object(forKey: url as AnyObject) as? UIImage {
            return decodedImage
        }
        
        // search for image data
        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
            let decodedImage = image.decodedImage()
            decodedImageCache.setObject(decodedImage as AnyObject, forKey: url as AnyObject)
            return decodedImage
        }
        
        return nil
    }
    
    func insertImage(_ image: UIImage?, for url: URL) {
        guard let image = image else { return removeImage(for: url) }
        let decodedImage = image.decodedImage()
        
        imageCache.setObject(image, forKey: url as AnyObject)
        decodedImageCache.setObject(decodedImage, forKey: url as AnyObject)
    }
    
    func removeImage(for url: URL) {
        imageCache.removeObject(forKey: url as AnyObject)
        decodedImageCache.removeObject(forKey: url as AnyObject)
    }
    
    func removeAllImages() {
        // TODO: clear caches
    }
    
    subscript(url: URL) -> UIImage? {
        get {
            return image(for: url)
        }
        set {
            return insertImage(newValue, for: url)
        }
    }
    
    
}
