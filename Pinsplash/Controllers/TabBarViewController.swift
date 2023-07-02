//
//  TabBarViewController.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 01/07/23.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - SETUP
    
    private func setup() {
        // Create base view controllers
        let homeVC = HomeViewController()
        let profileVC = ProfileViewController()
        
        homeVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house.fill"), selectedImage: nil)
        profileVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person.fill"), selectedImage: nil)
        
        // Wrap them in navigation controllers
        let homeNavVC = UINavigationController(rootViewController: homeVC)
        let profileNavVC = UINavigationController(rootViewController: profileVC)
        
        viewControllers = [homeNavVC, profileNavVC]
    }
    
}
