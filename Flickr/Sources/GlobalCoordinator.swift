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

    private let window: UIWindow?
    private var rootNav: UINavigationController?

    init(window: UIWindow?) {
        self.window = window
    }

    func setupRootViewController() {
        // new TabC object and call setup using obj, will be set to window!.setup here
        let tabsCoordinator = TabsCoordinator()
        window?.setupRootViewController(with: tabsCoordinator.setupRootViewController())
    }
}
