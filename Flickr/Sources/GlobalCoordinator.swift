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
    private var dbPool: DatabasePool?
    private var persistenceMangaer: PersistenceManager?

    init(window: UIWindow?) {
        self.window = window
        do {
            dbPool = try Persistence.connectToDB()
            persistenceMangaer = PersistenceManager(dbPool: dbPool!)
        } catch {
            dbPool = nil
            persistenceMangaer = nil
        }
    }

    func setupRootViewController() {
        // new TabC object and call setup using obj, will be set to window!.setup here
        if let persistenceMangaer = persistenceMangaer {
            let tabsCoordinator = TabsCoordinator(persistenceManager: persistenceMangaer)
            window?.setupRootViewController(with: tabsCoordinator.setupRootViewController())
        }
    }
}
