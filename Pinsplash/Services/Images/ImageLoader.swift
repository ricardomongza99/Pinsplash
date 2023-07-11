//
//  ImageLoader.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 27/06/23.
//

import UIKit

final class ImageLoader {
    
    static let shared = ImageLoader()
    private let imageCache = ImageCache()
    
    private init() {}
    
    func loadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        // Check the image cache
        if let image = imageCache[url] {
            DispatchQueue.main.async {
                completion(image)
            }
            return
        }
        
        // Not in cache
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching image: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            } else if let data = data {
                let image = UIImage(data: data)
                self.imageCache[url] = image
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
        
        task.resume()
    }
}
