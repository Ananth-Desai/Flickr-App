//
//  FavoritesCoordinator.swift
//  Flickr
//
//  Created by Ananth Desai on 20/03/22.
//

import Foundation
import UIKit

class FavoritesCoordinator {
    weak var rootNavigationController: UINavigationController!

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
        let photoViewerVC = PhotoViewerVC(url: nil, imageTitle: imageTitle, imageId: imageId, imageData: imageData)
        photoViewerVC.title = ""
        photoViewerVC.favoritesDelegate = self
        rootNavigationController.pushViewController(photoViewerVC, animated: true)
    }

    func getFavoriteImagesFromStorage() -> [FavoriteImageData]? {
        PersistenceManager.retrieveData()
    }

    func storeImageAsFavorite(imageData: Data, id: String, title: String) {
        var favorites = FavoriteImagesArray(array: [])
        favorites.array = PersistenceManager.retrieveData() ?? []
        let image = FavoriteImageData(imageId: id, imageData: imageData, imageTitle: title)
        favorites.array.append(image)
        PersistenceManager.storeData(favorites)
    }

    func removeImageFromFavorite(id: String) {
        var newFavoriteArray = FavoriteImagesArray(array: [])
        guard let favoriteArray = PersistenceManager.retrieveData() else {
            return
        }
        for photo in favoriteArray where photo.imageId != id {
            newFavoriteArray.array.append(photo)
        }
        PersistenceManager.storeData(newFavoriteArray)
    }
}

// MARK: Constants

private let navigationBarBackgroundColor = R.color.navigationBarBackground()
private let favoritesVcTitle = R.string.localizable.favorites()
