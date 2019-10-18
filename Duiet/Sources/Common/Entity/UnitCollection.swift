//
//  UnitCollection.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/10/14.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift

final class UnitCollection: Object {
    @objc dynamic var id = 0
    @objc dynamic var heightUnitRow: Int = 0
    @objc dynamic var weightUnitRow: Int = 0
    @objc dynamic var energyUnitRow: Int = 0

    @objc dynamic var createdAt = Date()
    @objc dynamic var updatedAt = Date()

    override static func primaryKey() -> String? {
        "id"
    }

    required convenience init(heightUnitRow: Int, weightUnitRow: Int, energyUnitRow: Int) {
        self.init()
        self.heightUnitRow = heightUnitRow
        self.weightUnitRow = weightUnitRow
        self.energyUnitRow = energyUnitRow
    }

    var heightUnit: Unit {
        HeightUnitType.get(heightUnitRow).unit
    }

    var weightUnit: Unit {
        WeightUnitType.get(weightUnitRow).unit
    }

    var energyUnit: Unit {
        EnergyUnitType.get(energyUnitRow).unit
    }
}
