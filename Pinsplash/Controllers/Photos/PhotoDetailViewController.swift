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
    
    private let scrollView: UIScrollView = {
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
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray5
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var detailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userContainerView])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
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
        let stackView = UIStackView(arrangedSubviews: [userLabel, userLikesLabel])
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    private let userLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    private let userLikesLabel: UILabel = {
        let label = UILabel()
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
        
    private lazy var saveButton: RoundButton = {
        let button = RoundButton()
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        button.setTitle("Save", for: .normal)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(weight: .bold), forImageIn: .normal)
        button.addTarget(self, action: #selector(shareButtonPressed), for: .touchUpInside)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadImages()
    }
    
    
    // MARK: - SETUP
    
    private func setup() {
        view.backgroundColor = .white
        
        setupSubviews()
        setupLayout()
        setupData()
        
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
    
    private func setupData() {
        userLabel.text = photo.user.name
        userLikesLabel.text = "\(photo.likes) likes"
        if let description = photo.description {
            descriptionLabel.text = description
            detailStackView.addArrangedSubview(descriptionLabel)
        }
    }
    
    private func loadImages() {
        if let url = URL(string: photo.urls.small) {
            photoImageView.load(url: url)
        }
        if let url = URL(string: photo.urls.regular) {
            photoImageView.load(url: url)
        }
        
        if let url = URL(string: photo.user.profileImage.small) {
            userProfileImageView.load(url: url)
        }
    }
    
    // MARK: - ACTIONS
    
    @objc private func saveButtonPressed() {
        // TODO: Save photo
    }
    
    @objc private func shareButtonPressed() {
        guard let photoUrl = URL(string: photo.urls.regular) else { return }
        ImageLoader.shared.loadImage(url: photoUrl) { [weak self] image in
            guard let image = image else { return }
            DispatchQueue.main.async {
                // TODO: Fix console logs
                let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                self?.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
}
