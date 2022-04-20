//
//  FileManagerCoordinator.swift
//  Flickr
//
//  Created by Ananth Desai on 01/04/22.
//

import Foundation
import GRDB

class PersistenceManager {
    static func retrieveData(dbPool: DatabasePool) -> [FavoriteImageData]? {
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

    static func createDB() -> DatabasePool? {
        var mainFolderUrl: URL
        var dbPath: URL
        var dbPool: DatabasePool
        do {
            mainFolderUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            dbPath = mainFolderUrl.appendingPathComponent("\(databaseName).db", isDirectory: false)
            dbPool = try DatabasePool(path: dbPath.absoluteString, configuration: GRDB.Configuration())
            var migrator = DatabaseMigrator()
            try Migrations.migrate(migrator: &migrator, dbPool: dbPool)

            return dbPool
        } catch {
            return nil
        }
    }
}

// MARK: Constants

private let fileName = "favorites.json"
private let databaseName = "favorites"
