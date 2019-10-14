//
//  UnitCollectionRepository.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/10/14.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift

protocol UnitCollectionRepositoryProtocol {
    /// Save UnitCollection
    /// - Parameter unitCollection: A collection of units selected by the user
    func add(unitCollection: UnitCollection)

    /// Use on the premise that there is always an acquisition target
    func get() -> UnitCollection
}

final class UnitCollectionRepository: UnitCollectionRepositoryProtocol {
    static let shared = UnitCollectionRepository()

    private let realm: Realm

    private init() {
        realm = try! Realm()
    }

    func add(unitCollection: UnitCollection) {
        try! realm.write {
            realm.add(unitCollection, update: .modified)
        }
    }

    func get() -> UnitCollection {
        realm.object(ofType: UnitCollection.self, forPrimaryKey: 0)!
    }
}
