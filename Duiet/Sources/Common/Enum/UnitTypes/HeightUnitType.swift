//
//  HeightUnitType.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/10/14.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

enum HeightUnitType: String, UnitType {
    case centimeters
    case feet

    var symbol: String {
        switch self {
        case .centimeters:
            return R.string.localizable.centimeters()

        case .feet:
            return R.string.localizable.feets()
        }
    }

    var row: Int {
        switch self {
        case .centimeters:
            return 0

        case .feet:
            return 1
        }
    }

    static func get(_ row: Int) -> UnitType {
        switch row {
        case 0:
            return centimeters

        case 1:
            return feet

        default:
            return centimeters
        }
    }
}
