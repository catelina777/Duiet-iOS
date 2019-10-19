//
//  EnergyUnitType.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/10/14.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

enum EnergyUnitType: String, UnitType {
    case kilocalories
    case kilojoules

    var unit: Unit {
        switch self {
        case .kilocalories:
            return UnitEnergy.kilocalories

        case .kilojoules:
            return UnitEnergy.kilojoules
        }
    }

    var row: Int {
        switch self {
        case .kilocalories:
            return 0

        case .kilojoules:
            return 1
        }
    }

    static func get(_ row: Int) -> UnitType {
        switch row {
        case 0:
            return kilocalories

        case 1:
            return kilojoules

        default:
            return kilocalories
        }
    }
}
