//
//  FavoritesCoordinatorDelegates.swift
//  Flickr
//
//  Created by Ananth Desai on 30/03/22.
//

import Foundation

protocol FavoritesViewControllerDelegate: AnyObject {
    func getFavoritesArray() -> [FavoriteImageData]?
    func selectedImageFromFavorites(imageData: Data, imageTitle: String, imageId: String)
    func pushToFavorites(imageData: Data, id: String, title: String)
    func popFromFavorites(id: String)
}
