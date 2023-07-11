//
//  ViewController.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 23/06/23.
//

import UIKit

class PhotosCollectionViewController: UIViewController {
    
    
    // MARK: - PROPERTIES
    
    private var photos: [Photo] = []
    private var photoService: PhotoFetching = PhotoService()
    
    
    // MARK: - COMPONENTS
    
    private let photosCollectionView: UICollectionView = {
        let layout = UICollectionViewWaterfallLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(PinCollectionViewCell.self, forCellWithReuseIdentifier: PinCollectionViewCell.reuseIdentifier)
        collectionView.register(LoadingFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingFooterView.identifier)
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
        
        fetchPhotos()
    }
    
    
    // MARK: - SETUP
    
    private func setup() {
        view.backgroundColor = .white
        
        setupSubviews()
        setupLayout()
        setupDelegates()
    }
    
    private func setupSubviews() {
        view.addSubview(photosCollectionView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            photosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photosCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photosCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupDelegates() {
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        if let layout = photosCollectionView.collectionViewLayout as? UICollectionViewWaterfallLayout {
            layout.delegate = self
        }
    }
    
    private func fetchPhotos() {
        photoService.fetchPhotos(query: "office") { newPhotos in
            if let newPhotos = newPhotos {
                let newIndexPaths = (self.photos.count..<(self.photos.count + newPhotos.count)).map { IndexPath(row: $0, section: 0) }
                self.photos.append(contentsOf: newPhotos)
                
                if self.photos.count == newPhotos.count {
                    DispatchQueue.main.async {
                        // First fetch
                        self.photosCollectionView.reloadData()
                    }
                } else {
                    DispatchQueue.main.async {
                        // Paginate
                        self.photosCollectionView.performBatchUpdates {
                            self.photosCollectionView.insertItems(at: newIndexPaths)
                        }
                    }
                }
            }
        }
    }
}


extension PhotosCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegateWaterallLayout, UICollectionViewDelegate {
    
    // MARK: UICollectionViewDataSource and delegate methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PinCollectionViewCell.reuseIdentifier, for: indexPath) as! PinCollectionViewCell
        cell.configure(with: photos[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGSize {
        return photos[indexPath.item].size
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 && !photoService.isLoading {
            self.fetchPhotos()
        }
    }
    
    /// Accesory views
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingFooterView.identifier, for: indexPath) as! LoadingFooterView
            footer.spinner.startAnimating()
            return footer
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return photoService.isLoading ? CGSize(width: collectionView.bounds.size.width, height: 50) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPhoto = photos[indexPath.item]
        let photoDetailVC = PhotoDetailViewController(selectedPhoto)
        present(photoDetailVC, animated: true)
    }
}

