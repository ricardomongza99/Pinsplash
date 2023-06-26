//
//  UIImageView+Extensions.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 25/06/23.
//

import UIKit

extension UIImageView {
    func load(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let request = ImageRequest(url: url)
        request.execute { [weak self] image in
            guard let image = image else { return }
            self?.image = image
        }
    }
}
