//
//  FavoritesCoordinatorExtension.swift
//  Flickr
//
//  Created by Ananth Desai on 30/03/22.
//

import Foundation

extension FavoritesCoordinator: FavoritesViewControllerDelegate {
    func getFavoritesArray() -> [FavoriteImageStructure]? {
        searchTabCoordinatorReference?.favoritesArray
    }
}
