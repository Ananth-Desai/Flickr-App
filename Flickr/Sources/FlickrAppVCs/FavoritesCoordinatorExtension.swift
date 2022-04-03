//
//  FavoritesCoordinatorExtension.swift
//  Flickr
//
//  Created by Ananth Desai on 30/03/22.
//

import Foundation

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
