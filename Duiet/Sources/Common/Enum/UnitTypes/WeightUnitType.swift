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

    var symbol: String {
        switch self {
        case .kilograms:
            return R.string.localizable.kilograms()

        case .pounds:
            return R.string.localizable.pounds()
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

    static func get(_ row: Int) -> WeightUnitType {
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
