//
//  TabsViewController.swift
//  Flickr-App
//
//  Created by Ananth Desai on 02/03/22.
//

import Foundation
import UIKit

class TabsVC: UIViewController {
    // MARK: Variables

    private var tabController: UITabBarController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarController()
    }

    func setupTabBarController() {
        let tabController = UITabBarController()
        tabController.tabBar.backgroundColor = tabbarBackgroundColor
        tabController.tabBar.tintColor = tabbarTintColor
        
        let homeVC = HomeScreenVC()
        homeVC.title = homeVcTitle
        if #available(iOS 13.0, *) {
            homeVC.tabBarItem = UITabBarItem(title: homeVcTitle, image: UIImage(systemName: "magnifyingglass"), tag: 0)
        } else {
            // Fallback on earlier versions
        }
        
        let favoritesVC = FavoritesVC()
        favoritesVC.title = favoritesVcTitle
        if #available(iOS 13.0, *) {
            favoritesVC.tabBarItem = UITabBarItem(title: favoritesVcTitle, image: UIImage(systemName: "heart"), tag: 0)
        } else {
            // Fallback on earlier versions
        }
        
        let viewControllerArray = [homeVC, favoritesVC]
        tabController.setViewControllers(viewControllerArray, animated: true)
        view.addSubview(tabController.view)
    }
}

// MARK: Constants

private let tabbarBackgroundColor = UIColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 0.94)
private let tabbarTintColor = UIColor(red: 0.952, green: 0.219, blue: 0.474, alpha: 1.0)
private let homeVcTitle = "Search"
private let favoritesVcTitle = "Favorites"
