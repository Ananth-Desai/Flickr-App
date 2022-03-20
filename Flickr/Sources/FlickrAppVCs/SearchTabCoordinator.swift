//
//  SearchTabCoordinator.swift
//  Flickr
//
//  Created by Ananth Desai on 20/03/22.
//

import Foundation
import UIKit

class SearchTabCoordinator {
    weak var rootNavigationController: UINavigationController?

    private func returnSearchScreenVC() -> UIViewController {
        let searchScreenVC = SearchScreenVC()
        searchScreenVC.searchScreenDelegate = self
        searchScreenVC.title = "Flickr"
        return searchScreenVC
    }

    func returnRootNavigator() -> UINavigationController {
        let searchScreenVC = returnSearchScreenVC()
        let rootNav = UINavigationController(rootViewController: searchScreenVC)
        rootNav.navigationBar.isTranslucent = false
        if #available(iOS 13.0, *) {
            let navbarAppearance = UINavigationBarAppearance()
            navbarAppearance.titleTextAttributes = [
                .font: UIFont(name: "Pacifico-Regular", size: 23)!,
                .foregroundColor: navigationBarTitleColor
            ]
            navbarAppearance.backgroundColor = navigationBarBackgroundColor
            rootNav.navigationBar.standardAppearance = navbarAppearance
            rootNav.navigationBar.scrollEdgeAppearance = navbarAppearance
        } else {
            // Fallback on earlier versions
        }
        rootNavigationController = rootNav
        return rootNav
    }
}

// MARK: Constants

private let navigationBarTitleColor = UIColor(red: 0.952, green: 0.219, blue: 0.474, alpha: 1.0)
private let navigationBarBackgroundColor = UIColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 0.94)
