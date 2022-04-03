//
//  SearchTabCoordinatorExtension.swift
//  Flickr
//
//  Created by Ananth Desai on 20/03/22.
//

import Foundation

extension SearchTabCoordinator: SearchScreenViewControllerDelegate {
    func didTapSearchButton(searchString: String) {
        let searchResultsVC = SearchResultsVC(searchString: searchString)
        searchResultsVC.searchResultsDelegate = self
        searchResultsVC.title = searchString
        rootNavigationController?.pushViewController(searchResultsVC, animated: true)
    }
}

extension SearchTabCoordinator: SearchResultsViewControllerDelegate {
    func didSelectImage(url: URL, title: String, imageTitle: String, imageId: String) {
        let photoViewerVC = PhotoViewerVC(url: url, imageTitle: imageTitle, imageId: imageId, imageData: nil)
        photoViewerVC.title = title
        photoViewerVC.photoViewerDelegate = self
        rootNavigationController?.pushViewController(photoViewerVC, animated: true)
    }
}

extension SearchTabCoordinator: PhotoViewerViewControllerDelegate {
    func pushToFavorites(imageData: Data, id: String, title: String) {
        var favorites = FavoriteImagesArray(array: [])
        let newArray = FileManagerCoordinator.retrieveData() ?? []
        favorites.array = newArray
        let image = FavoriteImageData(imageId: id, imageData: imageData, imageTitle: title)
        favorites.array.append(image)
        favoritesArray = favorites
        FileManagerCoordinator.storeData(favoritesArray)
    }

    func popFromFavorites(id: String) {
        var newFavoriteArray = FavoriteImagesArray(array: [])
        guard let favoriteArray = FileManagerCoordinator.retrieveData() else {
            return
        }
        for photo in favoriteArray where photo.imageId != id {
            newFavoriteArray.array.append(photo)
        }
        favoritesArray = newFavoriteArray
        FileManagerCoordinator.storeData(favoritesArray)
    }
}
