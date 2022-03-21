//
//  TabsViewController.swift
//  Flickr-App
//
//  Created by Ananth Desai on 02/03/22.
//

import Foundation
import UIKit

class TabsVC: UITabBarController {
    private var searchCoordinator: SearchTabCoordinator?
    private var favoritesCoordinator: FavoritesCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarController()
    }

    func setupTabBarController() {
        tabBar.backgroundColor = tabbarBackgroundColor
        tabBar.tintColor = tabbarTintColor

        let searchCoordinator = SearchTabCoordinator()
        self.searchCoordinator = searchCoordinator
        let searchVC = searchCoordinator.returnRootNavigator()
        searchVC.tabBarItem = UITabBarItem(title: homeVcTitle, image: UIImage(named: "Search Icon"), tag: 0)

        let favoritesCoordinator = FavoritesCoordinator()
        self.favoritesCoordinator = favoritesCoordinator
        let favoritesVC = favoritesCoordinator.returnRootNavigator()
        favoritesVC.tabBarItem = UITabBarItem(title: favoritesVcTitle, image: UIImage(named: "Heart Icon"), tag: 0)

        let viewControllerArray = [searchVC, favoritesVC]
        viewControllers = viewControllerArray
    }
}

// MARK: Constants

private let tabbarBackgroundColor = UIColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 0.94)
private let tabbarTintColor = UIColor(red: 0.952, green: 0.219, blue: 0.474, alpha: 1.0)
private let homeVcTitle = R.string.localizable.search()
private let favoritesVcTitle = R.string.localizable.favorites()
