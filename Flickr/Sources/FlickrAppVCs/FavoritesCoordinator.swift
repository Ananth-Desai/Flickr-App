//
//  FavoritesCoordinator.swift
//  Flickr
//
//  Created by Ananth Desai on 20/03/22.
//

import Foundation
import GRDB
import UIKit

class FavoritesCoordinator {
    weak var rootNavigationController: UINavigationController!
    var dbPool: DatabasePool

    init(dbPool: DatabasePool) {
        self.dbPool = dbPool
    }

    func returnRootNavigator() -> UINavigationController {
        let favoritesVC = FavoritesVC(dbPool: dbPool)
        favoritesVC.title = favoritesVcTitle
        favoritesVC.favoritesDelegate = self
        let rootNav = UINavigationController(rootViewController: favoritesVC)
        if #available(iOS 13.0, *) {
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

extension FavoritesCoordinator: FavoritesViewControllerDelegate {
    func selectedImageFromFavoritesVC(imageData: Data, imageTitle: String, imageId: String) {
        let photoViewerVC = PhotoViewerVC(url: nil, imageTitle: imageTitle, imageId: imageId, imageData: imageData, dbPool: dbPool)
        photoViewerVC.title = ""
        photoViewerVC.favoritesDelegate = self
        rootNavigationController.pushViewController(photoViewerVC, animated: true)
    }

    func getFavoriteImagesFromStorage() -> [FavoriteImageData]? {
        var favoriteimagesArray: [FavoriteImageData] = []
        do {
            try dbPool.read { db in
                let array = try Row.fetchCursor(db, sql: "SELECT * FROM favorites")
                while let item = try array.next() {
                    favoriteimagesArray.append(FavoriteImageData(imageId: item["id"], imageData: item["image"], imageTitle: item["name"]))
                }
            }
            return favoriteimagesArray
        } catch {
            return nil
        }
    }

    func storeImageAsFavorite(imageData: Data, id: String, title: String) {
        do {
            try dbPool.write { db in
                try db.execute(sql: "INSERT INTO favorites (id, name, image) VALUES (?, ?, ?)", arguments: [id, title, imageData])
            }
        } catch {
            return
        }
    }

    func removeImageFromFavorite(id: String) {
        do {
            try dbPool.write { db in
                try db.execute(sql: "DELETE FROM favorites WHERE id = ? ", arguments: [id])
            }
        } catch {
            return
        }
    }
}

// MARK: Constants

private let navigationBarBackgroundColor = R.color.navigationBarBackground()
private let favoritesVcTitle = R.string.localizable.favorites()
