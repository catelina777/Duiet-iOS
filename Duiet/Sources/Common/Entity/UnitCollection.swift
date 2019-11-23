//
//  UnitCollection.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/10.
//  Copyright © 2019 duiet. All rights reserved.
//

import CoreData
import Foundation
import RxCoreData
import RxDataSources

struct UnitCollection {
    var id: UUID
    var heightUnitRow: Int16
    var weightUnitRow: Int16
    var energyUnitRow: Int16
    var createdAt: Date
    var updatedAt: Date
}

extension UnitCollection: IdentifiableType {
    typealias Identity = String

    var identity: String { id.uuidString }
}

extension UnitCollection: Persistable {
    typealias T = UnitCollectionEntity

    static var entityName: String {
        T.className
    }

    static var primaryAttributeName: String {
        "id"
    }

    init(entity: Self.T) {
        id = entity.id!
        heightUnitRow = entity.heightUnitRow
        weightUnitRow = entity.weightUnitRow
        energyUnitRow = entity.energyUnitRow
        createdAt = entity.createdAt!
        updatedAt = entity.updatedAt!
    }

    func update(_ entity: UnitCollectionEntity) {
        entity.id = id
        entity.heightUnitRow = heightUnitRow
        entity.weightUnitRow = weightUnitRow
        entity.energyUnitRow = energyUnitRow
        entity.createdAt = createdAt
        entity.updatedAt = updatedAt
        do {
            try entity.managedObjectContext?.save()
        } catch let error {
            Logger.shared.error(error)
        }
    }
}

extension UnitCollection {
    var heightUnit: HeightUnitType {
        HeightUnitType.get(Int(heightUnitRow))
    }

    var weightUnit: WeightUnitType {
        WeightUnitType.get(Int(weightUnitRow))
    }

    var energyUnit: EnergyUnitType {
        EnergyUnitType.get(Int(energyUnitRow))
    }
}
