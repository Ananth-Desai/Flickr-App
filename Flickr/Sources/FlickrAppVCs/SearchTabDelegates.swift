//
//  SearchScreenDelegate.swift
//  Flickr
//
//  Created by Ananth Desai on 20/03/22.
//

import Foundation

protocol SearchScreenViewControllerDelegate: AnyObject {
    func didTapSearchButton(searchString: String)
}

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didSelectImage(url: URL, title: String, imageTitle: String)
}

protocol PhotoViewerViewControllerDelegate: AnyObject {
    func pushToFavorites(url: URL, title: String)
    func popFromFavorites(url: URL, title: String)
}
