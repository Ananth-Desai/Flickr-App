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
