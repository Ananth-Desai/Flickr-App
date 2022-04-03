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
    func didSelectImage(url: URL, title: String, imageTitle: String, imageId: String)
}

protocol PhotoViewerViewControllerDelegate: AnyObject {
    func pushToFavorites(imageData: Data, id: String, title: String)
    func popFromFavorites(id: String)
}
