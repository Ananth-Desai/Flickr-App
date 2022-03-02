//
// Copyright © 2022 Surya Software Systems Pvt. Ltd.
//

import UIKit

extension UIWindow {
    // Remove this comment if using default navigation
    func setupRootViewController(with viewController: UINavigationController) {
        // Set the initial View Controller to our instance of ViewController
        rootViewController = viewController
        // Present the window
        makeKeyAndVisible()
    }

//    Uncomment the following function if using TabBarController and remove the exiting `setupRootViewController` function
//    func setupRootViewController() {
//        // Create new Tab Bar Controller
//        let tabBarController = UITabBarController()
//        // Add view controllers to TabBarController
//        tabBarController.viewControllers = [
//            embedInNavController(ViewController(), title: "VC 1"),
//            embedInNavController(ViewController(), title: "VC 2")
//        ]
//        rootViewController = tabBarController
//
//        makeKeyAndVisible()
//    }
}

// Uncomment the following if using TabBarController
// private func embedInNavigationController(_ viewController, title: String) -> UINavigationController {
//    let navigationController = UINavigationController(rootViewController: viewController)
//    viewController.title = title
//    return navigationController
// }
