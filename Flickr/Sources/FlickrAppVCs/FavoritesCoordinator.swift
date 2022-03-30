//
//  FavoritesCoordinator.swift
//  Flickr
//
//  Created by Ananth Desai on 20/03/22.
//

import Foundation
import UIKit

class FavoritesCoordinator {
    weak var SearchTabCoordinatorReference: SearchTabCoordinator?

    init(searchTabCoordinatorReference: SearchTabCoordinator?) {
        SearchTabCoordinatorReference = searchTabCoordinatorReference
    }

    func returnRootNavigator() -> UINavigationController {
        let favoritesVC = FavoritesVC()
        favoritesVC.title = favoritesVcTitle
        favoritesVC.favoritesDelegate = self
        let rootNav = UINavigationController(rootViewController: favoritesVC)
        if #available(iOS 13.0, *) {
            let navbarAppearance = UINavigationBarAppearance()
            navbarAppearance.backgroundColor = navigationBarBackgroundColor
            rootNav.navigationBar.standardAppearance = navbarAppearance
            rootNav.navigationBar.scrollEdgeAppearance = navbarAppearance
        } else {
            // Fallback on earlier versions
            rootNav.navigationBar.backgroundColor = navigationBarBackgroundColor
        }
        return rootNav
    }
}

// MARK: Constants

private let navigationBarBackgroundColor = R.color.navigationBarBackground()
private let favoritesVcTitle = R.string.localizable.favorites()
