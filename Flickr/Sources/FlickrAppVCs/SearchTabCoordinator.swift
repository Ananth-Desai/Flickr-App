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
        let titleAttributes = [
            NSAttributedString.Key.font: UIFont(name: titleFontName, size: 23)!,
            NSAttributedString.Key.foregroundColor: navigationBarTitleColor
        ]
        let title = NSAttributedString(string: title, attributes: titleAttributes)
        let navLabel = UILabel()
        navLabel.attributedText = title
        searchScreenVC.navigationItem.titleView = navLabel
        return searchScreenVC
    }

    func returnRootNavigator() -> UINavigationController {
        let searchScreenVC = returnSearchScreenVC()
        let rootNav = UINavigationController(rootViewController: searchScreenVC)
        if #available(iOS 13.0, *) {
            rootNav.navigationBar.isTranslucent = false
            let navbarAppearance = UINavigationBarAppearance()
            navbarAppearance.backgroundColor = navigationBarBackgroundColor
            rootNav.navigationBar.standardAppearance = navbarAppearance
            rootNav.navigationBar.scrollEdgeAppearance = navbarAppearance
        } else {
            // Fallback on earlier versions
            rootNav.navigationBar.backgroundColor = navigationBarBackgroundColor
        }
        rootNavigationController = rootNav
        return rootNav
    }
}

// MARK: Constants

private let navigationBarTitleColor = R.color.navigationBarTintColor()
private let navigationBarBackgroundColor = R.color.navigationBarBackground()
private let titleFontName = "Pacifico-Regular"
private let title = "Flickr"
