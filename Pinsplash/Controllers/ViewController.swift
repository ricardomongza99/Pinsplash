//
//  ViewController.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 23/06/23.
//

import UIKit

class ViewController: UIViewController {
    
    
    // MARK: - PROPERTIES
    
    private var photos: [Photo] = TestData.photos
    private var photoService = PhotoService()
    
    
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
//        fetchPhotos()
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
        pinsCollectionView.delegate = self
        if let layout = pinsCollectionView.collectionViewLayout as? UICollectionViewWaterfallLayout {
            layout.delegate = self
        }
    }
    
    // TODO: Fix this buggy mess
    private func fetchPhotos() {
        photoService.fetchPhotos { photos in
            if let photos = photos {
                self.photos.append(contentsOf: photos)
                self.pinsCollectionView.reloadData()
            }
        }
    }
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateWaterallLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pinCell", for: indexPath) as! PinCollectionViewCell
        cell.configure(with: photos[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGSize {
        return photos[indexPath.item].size
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                self.fetchPhotos()
            }
        }
    }
}

