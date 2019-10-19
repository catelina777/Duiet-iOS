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

    var symbol: String {
        switch self {
        case .kilocalories:
            return R.string.localizable.kilocalories()

        case .kilojoules:
            return R.string.localizable.kilojoules()
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

    static func get(_ row: Int) -> EnergyUnitType {
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
