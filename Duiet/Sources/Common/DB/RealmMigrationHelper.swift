//
//  RealmMigrationHelper.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/29.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmMigrationHelper {
    static let shared = RealmMigrationHelper()

    private init() {}

    var defaultURL: URL {
        return Realm.Configuration.defaultConfiguration.fileURL!
    }

    var defaultParentURL: URL {
        return defaultURL.deletingLastPathComponent()
    }

    func doMigration() {
        let schemaVersion: UInt64 = 1
        let migrationBlock: MigrationBlock = { _, oldSchemaVersion in
            if oldSchemaVersion < 1 {}
        }
        let v0URL = defaultParentURL.appendingPathComponent("duiet-v0.realm")
        Realm.Configuration.defaultConfiguration = Realm.Configuration(fileURL: v0URL,
                                                                       schemaVersion: schemaVersion,
                                                                       migrationBlock: migrationBlock)
        _ = try! Realm()
    }

    private func bundleURL(_ name: String) -> URL? {
        return Bundle.main.url(forResource: name, withExtension: "realm")
    }
}
