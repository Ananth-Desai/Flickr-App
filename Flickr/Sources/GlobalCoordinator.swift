//
//  GlobalCoordinator.swift
//  Flickr-App
//
//  Created by Ananth Desai on 28/02/22.
//

import Foundation
import GRDB
import UIKit

class GlobalCoordinator {
    // MARK: Variables

    private let window: UIWindow?
    private var rootNav: UINavigationController?
    private var dbPool: DatabasePool

    init(window: UIWindow?) {
        self.window = window
        dbPool = PersistenceManager.createDB()!
    }

    func setupRootViewController() {
        // new TabC object and call setup using obj, will be set to window!.setup here
        let tabsCoordinator = TabsCoordinator(dbPool: dbPool)
        window?.setupRootViewController(with: tabsCoordinator.setupRootViewController())
    }
}
