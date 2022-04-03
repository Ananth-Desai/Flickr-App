//
//  SearchTabCoordinator.swift
//  Flickr
//
//  Created by Ananth Desai on 20/03/22.
//

import Foundation
import UIKit

class SearchTabCoordinator {
    weak var rootNavigationController: UINavigationController?
    var favoritesArray: FavoriteImagesArray? = FavoriteImagesArray(array: [])

    private func returnSearchScreenVC() -> UIViewController {
        let searchScreenVC = SearchScreenVC()
        searchScreenVC.searchScreenDelegate = self
        let titleAttributes = [
            NSAttributedString.Key.font: UIFont(name: titleFontName, size: 23)!,
            NSAttributedString.Key.foregroundColor: navigationBarTitleColor
        ]
        let title = NSAttributedString(string: title, attributes: titleAttributes)
        let navLabel = UILabel()
        navLabel.attributedText = title
        searchScreenVC.navigationItem.titleView = navLabel
        return searchScreenVC
    }

    func returnRootNavigator() -> UINavigationController {
        let searchScreenVC = returnSearchScreenVC()
        let rootNav = UINavigationController(rootViewController: searchScreenVC)
        if #available(iOS 13.0, *) {
            rootNav.navigationBar.isTranslucent = false
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

// MARK: Constants

private let navigationBarTitleColor = R.color.navigationBarTintColor()
private let navigationBarBackgroundColor = R.color.navigationBarBackground()
private let titleFontName = "Pacifico-Regular"
private let title = "Flickr"
