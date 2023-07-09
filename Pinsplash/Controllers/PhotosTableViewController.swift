//
//  PhotosTableViewController.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 27/06/23.
//

import UIKit

class PhotosTableViewController: UITableViewController {
    
    // MARK: - PROPERTIES
    
    private var photos: [Photo] = []
    
    // MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchPhotos()
    }
    
    // MARK: - SETUP
    
    private func fetchPhotos() {
        // TODO: Fetch photos
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotoTableViewCell
        cell.configure(with: photos[indexPath.item])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
