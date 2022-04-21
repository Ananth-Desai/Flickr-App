//
//  FileManagerCoordinator.swift
//  Flickr
//
//  Created by Ananth Desai on 01/04/22.
//

import Foundation
import GRDB

class PersistenceManager {
    // MARK: Variables

    private var dbPool: DatabasePool

    init(dbPool: DatabasePool) {
        self.dbPool = dbPool
    }

    func retrieveData() -> [FavoriteImageData]? {
        var favoriteimagesArray: [FavoriteImageData] = []
        do {
            try
                dbPool.read { db in
                    let newArray = try Favorites.fetchAll(db)
                    for image in newArray {
                        favoriteimagesArray.append(FavoriteImageData(imageId: image.id, imageData: image.image, imageTitle: image.name))
                    }
                }
            return favoriteimagesArray
        } catch {
            return nil
        }
    }

    func storeImageIntoDatabase(imageData: Data, id: String, title: String) {
        do {
            try dbPool.write { db in
                try Favorites(id: id, name: title, image: imageData).insert(db)
            }
        } catch {
            return
        }
    }

    func removeImageFromFavorites(id: String) {
        do {
            try dbPool.write { db in
                try Favorites.filter(Favorites.CNAMEs.id == id).deleteAll(db)
            }
        } catch {
            return
        }
    }
}

// MARK: Constants

private let fileName = "favorites.json"
private let databaseName = "favorites"
