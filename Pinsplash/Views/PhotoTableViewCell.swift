//
//  PhotoTableViewCell.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 27/06/23.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    
    // MARK: - COMPONENTS
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [photoImageView, descriptionLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    // MARK: - SETUP
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            photoImageView.widthAnchor.constraint(equalToConstant: 80)
            
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - SETUP
    
    func configure(with photo: Photo) {
        guard let url = URL(string: photo.urls.small) else { return }
        photoImageView.image = nil
        photoImageView.load(url: url)
        descriptionLabel.text = "Author: \(photo.user.name), likes: \(photo.likes)"
    }
}
