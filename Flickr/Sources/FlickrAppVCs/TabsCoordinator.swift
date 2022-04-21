//
//  TabsCoordinator.swift
//  Flickr-App
//
//  Created by Ananth Desai on 28/02/22.
//

import Foundation
import GRDB
import UIKit

class TabsCoordinator {
    var persistenceManager: PersistenceManager

    init(persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
    }

    func setupRootViewController() -> UIViewController {
        let searchTabCoordinator = SearchTabCoordinator(persistenceManager: persistenceManager)
        let favoritesCoordinator = FavoritesCoordinator(persistenceManager: persistenceManager)
        let tabsVC = TabsVC(searchCoordinator: searchTabCoordinator, favoritesCoordinator: favoritesCoordinator)
        return tabsVC
    }
}
