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
    private var photoService = PhotoService()
    
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
        photoService.fetchPhotos { newPhotos in
            if let newPhotos = newPhotos {
                let newIndexPaths = (self.photos.count..<(self.photos.count + newPhotos.count)).map { IndexPath(row: $0, section: 0) }
                self.photos.append(contentsOf: newPhotos)
                DispatchQueue.main.async {
                    if self.photos.count == newPhotos.count {
                        // First fetch
                        self.tableView.reloadData()
                    } else {
                        // Paginate
                        self.tableView.beginUpdates()
                        self.tableView.insertRows(at: newIndexPaths, with: .fade)
                        self.tableView.endUpdates()
                    }

                }
            }
        }
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 && !photoService.isLoading {
            fetchPhotos()
        }
    }


}
