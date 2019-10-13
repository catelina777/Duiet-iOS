//
//  UnitLocalizable.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/10/13.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

private let formatter = MeasurementFormatter()

protocol UnitLocalizable {
    func unitSymbol(_ unit: Unit, style: MeasurementFormatter.UnitStyle) -> String
}

extension UnitLocalizable {
    func unitSymbol(_ unit: Unit, style: MeasurementFormatter.UnitStyle) -> String {
        formatter.unitStyle = style
        return formatter.string(from: unit)
    }
}
