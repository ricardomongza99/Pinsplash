//
//  RoundButton.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 01/07/23.
//

import UIKit

class RoundButton: UIButton {
    
    
    // MARK: - PROPERTIES
    
    enum ButtonType {
        case primary
        case secondary
    }

    var type: RoundButton.ButtonType = .primary {
        didSet {
            setup()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let originalSize = super.intrinsicContentSize
        let height = max(originalSize.height, 44)
        let width = originalSize.width + 44
        return CGSize(width: width, height: height)
    }

    
    // MARK: - INITIALIZERS
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - LIFECYCLE
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    
    // MARK: - SETUP
    
    func setup() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        


        switch type {
        case .primary:
            self.backgroundColor = UIColor(red: 0.90, green: 0.00, blue: 0.14, alpha: 1.00)
            self.setTitleColor(.white, for: .normal)
        case .secondary:
            self.backgroundColor = UIColor.systemGray5
            self.setTitleColor(.black, for: .normal)
        }
    }

}
