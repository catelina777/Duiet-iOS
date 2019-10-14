//
//  WeightUnitType.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/10/14.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

enum WeightUnitType: String, UnitType {
    case kilograms
    case pounds

    var abbr: String {
        switch self {
        case .kilograms:
            return "kg"

        case .pounds:
            return "lb"
        }
    }

    var unit: Unit {
        switch self {
        case .kilograms:
            return UnitMass.kilograms

        case .pounds:
            return UnitMass.pounds
        }
    }

    var row: Int {
        switch self {
        case .kilograms:
            return 0

        case .pounds:
            return 1
        }
    }

    static func get(_ row: Int) -> UnitType {
        switch row {
        case 0:
            return kilograms

        case 1:
            return pounds

        default:
            return kilograms
        }
    }
}
