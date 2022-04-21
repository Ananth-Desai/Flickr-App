//
//  Persistence.swift
//  Flickr
//
//  Created by Ananth Desai on 21/04/22.
//

import Foundation
import GRDB

class Persistence {
    static func connectToDB() throws -> DatabasePool {
        let mainFolderUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let dbPath = mainFolderUrl.appendingPathComponent("\(databaseName).db", isDirectory: false)
        let dbPool = try DatabasePool(path: dbPath.absoluteString, configuration: GRDB.Configuration())
        var migrator = DatabaseMigrator()
        try Migrations.migrate(migrator: &migrator, dbPool: dbPool)

        return dbPool
    }
}

// MARK: Constants

private let databaseName = "favorites"
