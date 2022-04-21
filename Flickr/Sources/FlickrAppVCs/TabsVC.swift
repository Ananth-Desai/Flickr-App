//
//  TabsViewController.swift
//  Flickr-App
//
//  Created by Ananth Desai on 02/03/22.
//

import Foundation
import GRDB
import UIKit

class TabsVC: UITabBarController {
    private var searchCoordinator: SearchTabCoordinator?
    private var favoritesCoordinator: FavoritesCoordinator?
    var persistenceManager: PersistenceManager?

    init(persistenceManager: PersistenceManager?) {
        self.persistenceManager = persistenceManager
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesSearchBarWhenScrolling = true
        setupTabBarController()
    }

    func setupTabBarController() {
        tabBar.backgroundColor = tabbarBackgroundColor
        tabBar.tintColor = tabbarTintColor

        let searchCoordinator = SearchTabCoordinator(persistenceManager: persistenceManager)
        self.searchCoordinator = searchCoordinator
        let searchVC = searchCoordinator.returnRootNavigator()
        searchVC.tabBarItem = UITabBarItem(title: homeVcTitle, image: searchIcon, tag: 0)

        let favoritesCoordinator = FavoritesCoordinator(persistenceManager: persistenceManager)
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
