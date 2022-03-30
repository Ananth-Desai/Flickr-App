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
        searchVC.tabBarItem = UITabBarItem(title: homeVcTitle, image: searchIcon, tag: 0)

        let favoritesCoordinator = FavoritesCoordinator(searchTabCoordinatorReference: searchCoordinator)
        self.favoritesCoordinator = favoritesCoordinator
        let favoritesVC = favoritesCoordinator.returnRootNavigator()
        favoritesVC.tabBarItem = UITabBarItem(title: favoritesVcTitle, image: favoritesIcon, tag: 0)

        let viewControllerArray = [searchVC, favoritesVC]
        viewControllers = viewControllerArray
    }
}

// MARK: Constants

private let tabbarBackgroundColor = R.color.tabBarBackground()
private let tabbarTintColor = R.color.tabBarTintColor()
private let homeVcTitle = R.string.localizable.search()
private let favoritesVcTitle = R.string.localizable.favorites()
private let searchIcon = R.image.searchIcon()
private let favoritesIcon = R.image.heartIcon()
