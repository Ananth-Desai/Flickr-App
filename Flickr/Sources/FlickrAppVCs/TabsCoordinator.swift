//
//  TabsCoordinator.swift
//  Flickr-App
//
//  Created by Ananth Desai on 28/02/22.
//

import Foundation
import UIKit

class TabsCoordinator {
    // function that returns a UIViewController, needs to be pushed to nav using window!.setup

    func setupRootViewController() -> UIViewController {
        let tabsVC = TabsVC()
        return tabsVC
    }
}
