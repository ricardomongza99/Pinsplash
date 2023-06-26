//
//  ViewController.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 23/06/23.
//

import UIKit

class ViewController: UIViewController {
    
    
    // MARK: - PROPERTIES
    
    
    private var photos = TestData.photos
    private var images: [UIImage] = []
    
    
    // MARK: - COMPONENTS
    
    private let pinsCollectionView: UICollectionView = {
        let layout = UICollectionViewWaterfallLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(PinCollectionViewCell.self, forCellWithReuseIdentifier: "pinCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    // MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        fetchUnsplashPhotos()
        fetchImages()
    }
    
    
    // MARK: - SETUP
    
    private func setup() {
        view.backgroundColor = .white
        
        setupSubviews()
        setupLayout()
        setupDelegates()
    }
    
    private func setupSubviews() {
        view.addSubview(pinsCollectionView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            pinsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pinsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pinsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pinsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupDelegates() {
        pinsCollectionView.dataSource = self
        if let layout = pinsCollectionView.collectionViewLayout as? UICollectionViewWaterfallLayout {
            layout.delegate = self
        }
    }
    
    // TODO: Replace
    private func fetchUnsplashPhotos() {
        let resource = PhotosResource()
        let request = APIRequest(resource: resource)
        request.execute { photos in
            if let photos = photos {
                print(photos[0].urls.full)
            } else {
                print("Coundn't get photos")
            }
        }
    }
    
    // TODO: Replace with image cacheing
    private func fetchImages() {
        for photo in self.photos {
            let request = ImageRequest(url: URL(string: photo.urls.small)!)
            request.execute { image in
                guard let image = image else { return }
                self.images.append(image)
                
                DispatchQueue.main.async {
                    self.pinsCollectionView.reloadData()
                }
            }
        }
    }
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateWaterallLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pinCell", for: indexPath) as! PinCollectionViewCell
        cell.image = images[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGSize {
        return images[indexPath.item].size
    }
}

