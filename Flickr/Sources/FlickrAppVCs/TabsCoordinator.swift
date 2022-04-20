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
    var dbPool: DatabasePool

    init(dbPool: DatabasePool) {
        self.dbPool = dbPool
    }

    func setupRootViewController() -> UIViewController {
        let tabsVC = TabsVC(dbPool: dbPool)
        return tabsVC
    }
}
