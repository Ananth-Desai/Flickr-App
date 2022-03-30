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
    func didSelectImage(url: URL, title: String, imageTitle: String) {
        let photoViewerVC = PhotoViewerVC(url: url, imageTitle: imageTitle)
        photoViewerVC.title = title
        photoViewerVC.photoViewerDelegate = self
        rootNavigationController?.pushViewController(photoViewerVC, animated: true)
    }
}

extension SearchTabCoordinator: PhotoViewerViewControllerDelegate {
    func pushToFavorites(url: URL, title: String) {
        let image = FavoriteImageStructure(url: url, title: title)
        favoritesArray?.append(image)
    }

    func popFromFavorites(url _: URL, title: String) {
        var newFavoriteArray: [FavoriteImageStructure]? = []
        guard let favoriteArray = favoritesArray else {
            return
        }
        for photo in favoriteArray where photo.imageTitle != title {
            newFavoriteArray?.append(photo)
        }
        favoritesArray = newFavoriteArray
    }
}
