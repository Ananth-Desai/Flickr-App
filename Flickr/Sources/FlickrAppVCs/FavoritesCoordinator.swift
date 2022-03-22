//
//  FavoritesCoordinator.swift
//  Flickr
//
//  Created by Ananth Desai on 20/03/22.
//

import Foundation
import UIKit

class FavoritesCoordinator {
    func returnRootNavigator() -> UINavigationController {
        let favoritesVC = FavoritesVC()
        favoritesVC.title = favoritesVcTitle
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

private let navigationBarBackgroundColor = UIColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 0.94)
private let favoritesVcTitle = NSLocalizedString("favorites", comment: "")
