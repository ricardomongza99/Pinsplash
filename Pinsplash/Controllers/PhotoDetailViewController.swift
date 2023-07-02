//
//  PhotoDetailViewController.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 01/07/23.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    // MARK: - PROPERTIES
    
    private let photo: Photo
    
    
    // MARK: - SUBVIEWS
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [photoImageView, descriptionStackView])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray5
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        if let description = photo.description {
            descriptionLabel.text = description
            stackView.insertArrangedSubview(descriptionLabel, at: 0)
        }
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return stackView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    
    // MARK: - INITIALIZERS
    
    init(_ photo: Photo) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    // MARK: - SETUP
    
    private func setup() {
        view.backgroundColor = .white
        
        setupSubviews()
        setupLayout()
        loadImage()
    }
    
    private func setupSubviews() {
        view.addSubview(stackView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            
            photoImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor, multiplier: photo.aspectRatio)
        ])
    }
    
    private func loadImage() {
        if let url = URL(string: photo.urls.small) {
            photoImageView.load(url: url)
        }
        if let url = URL(string: photo.urls.full) {
            photoImageView.load(url: url)
        }
    }
    

}
