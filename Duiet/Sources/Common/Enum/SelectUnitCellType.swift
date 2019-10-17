//
//  SelectUnitCellType.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/10/16.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

enum SelectUnitCellType: CaseIterable {
    case height
    case weight
    case energy

    var title: String {
        switch self {
        case .height:
            return "Height"
        case .weight:
            return "Weight"
        case .energy:
            return "Energy"
        }
    }

    var pairedUniTypes: (UnitType, UnitType) {
        switch self {
        case .height:
            return (HeightUnitType.centimeters, HeightUnitType.feet)

        case .weight:
            return (WeightUnitType.kilograms, WeightUnitType.pounds)

        case .energy:
            return (EnergyUnitType.kilocalories, EnergyUnitType.kilojoules)
        }
    }
}
