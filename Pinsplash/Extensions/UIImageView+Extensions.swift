//
//  UIImageView+Extensions.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 25/06/23.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        ImageLoader.shared.loadImage(url: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
