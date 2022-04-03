//
//  FavoritesCoordinator.swift
//  Flickr
//
//  Created by Ananth Desai on 20/03/22.
//

import Foundation
import UIKit

class FavoritesCoordinator {
    weak var searchTabCoordinatorReference: SearchTabCoordinator?
    weak var rootNavigationController: UINavigationController!

    init(searchTabCoordinatorReference: SearchTabCoordinator?) {
        self.searchTabCoordinatorReference = searchTabCoordinatorReference
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
    func selectedImageFromFavorites(imageData: Data, imageTitle: String, imageId: String) {
        let photoViewerVC = PhotoViewerVC(url: nil, imageTitle: imageTitle, imageId: imageId, imageData: imageData)
        photoViewerVC.title = ""
        photoViewerVC.favoritesDelegate = self
        rootNavigationController.pushViewController(photoViewerVC, animated: true)
    }

    func getFavoritesArray() -> [FavoriteImageData]? {
        FileManagerCoordinator.retrieveData()
    }

    func pushToFavorites(imageData: Data, id: String, title: String) {
        var favorites = FavoriteImagesArray(array: [])
        favorites.array = FileManagerCoordinator.retrieveData() ?? []
        let image = FavoriteImageData(imageId: id, imageData: imageData, imageTitle: title)
        favorites.array.append(image)
        FileManagerCoordinator.storeData(favorites)
    }

    func popFromFavorites(id: String) {
        var newFavoriteArray = FavoriteImagesArray(array: [])
        guard let favoriteArray = FileManagerCoordinator.retrieveData() else {
            return
        }
        for photo in favoriteArray where photo.imageId != id {
            newFavoriteArray.array.append(photo)
        }
        FileManagerCoordinator.storeData(newFavoriteArray)
    }
}

// MARK: Constants

private let navigationBarBackgroundColor = R.color.navigationBarBackground()
private let favoritesVcTitle = R.string.localizable.favorites()
