//
//  FavoritesCoordinatorDelegates.swift
//  Flickr
//
//  Created by Ananth Desai on 30/03/22.
//

import Foundation

protocol FavoritesViewControllerDelegate: AnyObject {
    func getFavoritesArray() -> [FavoriteImageStructure]?
}
