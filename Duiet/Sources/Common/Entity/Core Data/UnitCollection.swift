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
    typealias T = NSManagedObject

    static var entityName: String {
        "UnitCollection"
    }

    static var primaryAttributeName: String {
        "id"
    }

    init(entity: Self.T) {
        id = entity.value(forKey: "id") as! UUID
        heightUnitRow = entity.value(forKey: "heightUnitRow") as! Int16
        weightUnitRow = entity.value(forKey: "weightUnitRow") as! Int16
        energyUnitRow = entity.value(forKey: "energyUnitRow") as! Int16
        createdAt = entity.value(forKey: "createdAt") as! Date
        updatedAt = entity.value(forKey: "updatedAt") as! Date
    }

    func update(_ entity: NSManagedObject) {
        entity.setValue(id, forKey: "id")
        entity.setValue(heightUnitRow, forKey: "heightUnitRow")
        entity.setValue(weightUnitRow, forKey: "weightUnitRow")
        entity.setValue(energyUnitRow, forKey: "energyUnitRow")
        entity.setValue(createdAt, forKey: "createdAt")
        entity.setValue(updatedAt, forKey: "updatedAt")
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