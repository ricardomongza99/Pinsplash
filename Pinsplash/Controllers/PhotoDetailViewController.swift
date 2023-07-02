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
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = false 
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [photoImageView, detailStackView, footerStackView])
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
    
    private lazy var detailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userContainerView])
        if let description = photo.description {
            descriptionLabel.text = description
            stackView.insertArrangedSubview(descriptionLabel, at: 1)
        }
        stackView.axis = .vertical
        stackView.spacing = 16
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
    
    private lazy var userContainerView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userProfileImageView, userStackView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray5
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.systemGray5.cgColor
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var userStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userLabel, userFollowersLabel])
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var userLabel: UILabel = {
        let label = UILabel()
        label.text = photo.user.name
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    private lazy var userFollowersLabel: UILabel = {
        let label = UILabel()
        label.text = "\(photo.user.totalLikes) likes"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private lazy var footerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [commentButton, buttonsStackView, shareButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return stackView
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(weight: .bold), forImageIn: .normal)
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [viewButton, saveButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private let viewButton: RoundButton = {
        let button = RoundButton()
        button.type = .secondary
        button.setTitle("View", for: .normal)
        return button
    }()
        
    private let saveButton: RoundButton = {
        let button = RoundButton()
        button.setTitle("Save", for: .normal)
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(weight: .bold), forImageIn: .normal)
        return button
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
        
        viewButton.sizeToFit()
    }
    
    private func setupSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            photoImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor, multiplier: photo.aspectRatio),
            
            userProfileImageView.widthAnchor.constraint(equalToConstant: 40),
            userProfileImageView.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func loadImage() {
        if let url = URL(string: photo.urls.small) {
            photoImageView.load(url: url)
        }
        if let url = URL(string: photo.urls.full) {
            photoImageView.load(url: url)
        }
        
        if let url = URL(string: photo.user.profileImage.small) {
            userProfileImageView.load(url: url)
        }
    }
    

}
