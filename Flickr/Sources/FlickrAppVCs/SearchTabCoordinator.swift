//
//  NewSearchTabCoordinator.swift
//  Flickr
//
//  Created by Ananth Desai on 10/04/22.
//

import Foundation
import GRDB
import RxSwift
import UIKit

class SearchTabCoordinator {
    weak var rootNavigationController: UINavigationController?
    private var searchString: String?
    var favoritesArray: FavoriteImagesArray? = FavoriteImagesArray(array: [])
    var persistenceManager: PersistenceManager

    init(persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
    }

    private func returnSearchScreenVC() -> UIViewController {
        let searchScreenVC = SearchScreenVC()
        searchScreenVC.searchResultsDelegate = self
        let titleAttributes = [
            NSAttributedString.Key.font: UIFont(name: titleFontName, size: 23)!,
            NSAttributedString.Key.foregroundColor: navigationBarTitleColor
        ]
        let title = NSAttributedString(string: title, attributes: titleAttributes as [NSAttributedString.Key: Any])
        let navLabel = UILabel()
        navLabel.attributedText = title
        searchScreenVC.navigationItem.titleView = navLabel
        searchScreenVC.navigationItem.searchController = returnSearchController()
        return searchScreenVC
    }

    private func returnSearchController() -> UISearchController {
        let searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.keyboardType = .webSearch
        return searchController
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
    func didSelectImage(url: URL, title: String, imageTitle: String, imageId: String) {
        let photoViewerVC = PhotoViewerVC(url: url, imageTitle: imageTitle, imageId: imageId, imageData: nil, favoritesArray: persistenceManager.retrieveData())
        photoViewerVC.title = title
        photoViewerVC.photoViewerDelegate = self
        rootNavigationController?.pushViewController(photoViewerVC, animated: true)
    }
}

extension SearchTabCoordinator: PhotoViewerViewControllerDelegate {
    func getFavoriteImagesFromStorage() -> [FavoriteImageData]? {
        persistenceManager.retrieveData()
    }

    func storeImageAsFavorite(imageData: Data, id: String, title: String) {
        persistenceManager.storeImageIntoDatabase(imageData: imageData, id: id, title: title)
    }

    func removeImageFromFavorites(id: String) {
        persistenceManager.removeImageFromFavorites(id: id)
    }
}

// MARK: Constants

private let navigationBarTitleColor = R.color.navigationBarTintColor()
private let navigationBarBackgroundColor = R.color.navigationBarBackground()
private let titleFontName = "Pacifico-Regular"
private let title = "Flickr"
