//
//  MigrationsManager.swift
//  Flickr
//
//  Created by Ananth Desai on 20/04/22.
//

import Foundation
import GRDB

enum Migrations {
    static func migrate(migrator: inout DatabaseMigrator, dbPool: DatabasePool) throws {
        migrator.registerMigration("v1") { database in
            try database.create(table: "favorites") { table in
                table.column("id").notNull()
                table.column("name", .text).notNull()
                table.column("image", .any).notNull()
            }
        }
        try migrator.migrate(dbPool)
    }
}
