//
//  ViewController.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 23/06/23.
//

import UIKit

class ViewController: UIViewController {
    
    
    // MARK: - PROPERTIES
    
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
        // TODO: fetch images
        
        // TODO: replace this
        for i in 1...18 {
            images.append(UIImage(named: "totoro-\(i)")!)
        }
        pinsCollectionView.reloadData()
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
}


extension ViewController: UICollectionViewDataSource, UICollectionViewWaterallLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pinCell", for: indexPath) as! PinCollectionViewCell
        cell.image = images[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGSize {
        return images[indexPath.row].size
    }
}

