//
//  FavoritesCoordinator.swift
//  Flickr
//
//  Created by Ananth Desai on 20/03/22.
//

import Foundation
import GRDB
import UIKit

class FavoritesCoordinator {
    weak var rootNavigationController: UINavigationController!
    var persistenceManager: PersistenceManager?

    init(persistenceManager: PersistenceManager?) {
        self.persistenceManager = persistenceManager
    }

    func returnRootNavigator() -> UINavigationController {
        let favoritesVC = FavoritesVC()
        favoritesVC.title = favoritesVcTitle
        favoritesVC.favoritesDelegate = self
        let rootNav = UINavigationController(rootViewController: favoritesVC)
        if #available(iOS 13.0, *) {
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

// MARK: Extensions

extension FavoritesCoordinator: FavoritesViewControllerDelegate {
    func selectedImageFromFavoritesVC(imageData: Data, imageTitle: String, imageId: String) {
        let photoViewerVC = PhotoViewerVC(url: nil, imageTitle: imageTitle, imageId: imageId, imageData: imageData, favoritesArray: persistenceManager?.retrieveData())
        photoViewerVC.title = ""
        photoViewerVC.favoritesDelegate = self
        rootNavigationController.pushViewController(photoViewerVC, animated: true)
    }

    func getFavoriteImagesFromStorage() -> [FavoriteImageData]? {
        persistenceManager?.retrieveData()
    }

    func storeImageAsFavorite(imageData: Data, id: String, title: String) {
        persistenceManager?.storeImageIntoDatabase(imageData: imageData, id: id, title: title)
    }

    func removeImageFromFavorite(id: String) {
        persistenceManager?.removeImageFromFavorites(id: id)
    }
}

// MARK: Constants

private let navigationBarBackgroundColor = R.color.navigationBarBackground()
private let favoritesVcTitle = R.string.localizable.favorites()
