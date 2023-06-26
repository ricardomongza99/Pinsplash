//
//  ViewController.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 23/06/23.
//

import UIKit

class ViewController: UIViewController {
    
    
    // MARK: - PROPERTIES
        
    private var imageUrls: [URL] = [URL(string: "https://i.pinimg.com/564x/55/ef/e9/55efe92c37077e07ca85d8234c7798cc.jpg")!,
                                    URL(string: "https://i.pinimg.com/564x/a1/20/15/a120156fa1843c8bbfba074a62c60511.jpg")!,
                                    URL(string: "https://i.pinimg.com/564x/25/5a/8b/255a8bcab3da16c62d3cbc1f119dbbcd.jpg")!,
                                    URL(string: "https://i.pinimg.com/564x/ab/f4/9c/abf49c0efc60ade9e109e59a2ab12b87.jpg")!,
                                    URL(string: "https://i.pinimg.com/564x/86/ec/5f/86ec5f14585db36c9597d0c7a032422c.jpg")!,
                                    URL(string: "https://i.pinimg.com/564x/b6/3b/7f/b63b7f9571158969dff1cc8ba6ec8daa.jpg")!,
                                    URL(string: "https://i.pinimg.com/564x/29/b9/a6/29b9a60928bc7350f678d7cad3d7e093.jpg")!,
                                    URL(string: "https://i.pinimg.com/564x/28/d9/7c/28d97c864af7f0515ebe138d68a71297.jpg")!,
                                    URL(string: "https://i.pinimg.com/564x/9f/0d/8a/9f0d8ae13f688cf8b876b44f3d959440.jpg")!,
                                    URL(string: "https://i.pinimg.com/564x/b9/40/e2/b940e29981afe67ba25d397c896dace6.jpg")!,
                                    URL(string: "https://i.pinimg.com/564x/09/ac/53/09ac53afa2265d7bfe53392b69e47d98.jpg")!,
                                    URL(string: "https://i.pinimg.com/736x/ea/57/40/ea5740dc2e873c79f12f55c2e0dd5011.jpg")!,
                                    URL(string: "https://i.pinimg.com/564x/1e/d7/2b/1ed72b8e3d860c693c0b49f4671e8093.jpg")!,
                                    URL(string: "https://i.pinimg.com/564x/67/0e/bd/670ebd4b2b008383dccd6e3fe668cfba.jpg")!]
    
    private var images: [UIImage] = []
    
    private var photos = TestData.photos
    
    
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
        fetchUnsplashPhotos()
//        fetchImages()
//        print(photos[0].urls.small)
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
        DispatchQueue.global().async {
            for imageUrl in self.imageUrls {
                let data = try? Data(contentsOf: imageUrl)
                self.images.append(UIImage(data: data!)!)

            }
            DispatchQueue.main.async {
                self.pinsCollectionView.reloadData()
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

