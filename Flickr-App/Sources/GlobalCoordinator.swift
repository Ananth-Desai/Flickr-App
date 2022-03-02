//
//  GlobalCoordinator.swift
//  Flickr-App
//
//  Created by Ananth Desai on 28/02/22.
//

import Foundation
import UIKit

class GlobalCoordinator {
    // MARK: Variables

    private let window: UIWindow!
    private var rootNav: UINavigationController?

    init(window: UIWindow) {
        self.window = window
    }

    func setupRootViewController() {
        // new TabC object and call setup using obj, will be set to window!.setup here
        let tabsCoordinator = TabsCoordinator()
        let navController = UINavigationController(rootViewController: tabsCoordinator.setupRootViewController())
        navController.navigationBar.isTranslucent = false
        if #available(iOS 13.0, *) {
            let navbarAppearance = UINavigationBarAppearance()
            navbarAppearance.titleTextAttributes = [
                .font: UIFont(name: "Noteworthy", size: 24)!,
                .foregroundColor: navigationBarTitleColor
            ]
            navbarAppearance.backgroundColor = navigationBarBackgroundColor
            navController.navigationBar.standardAppearance = navbarAppearance
            navController.navigationBar.scrollEdgeAppearance = navbarAppearance
        } else {
            // Fallback on earlier versions
        }
        self.rootNav = navController
        window.setupRootViewController(with: rootNav!)
    }
}

// MARK: Constants
private let navigationBarTitleColor = UIColor(red: 0.952, green: 0.219, blue: 0.474, alpha: 1.0)
private let navigationBarBackgroundColor = UIColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 0.94)
