//
//  UnitLocalizeHelper.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/10/19.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

protocol HeightUnitLocalizable {
    func convert(value: Double, from fromUnitType: HeightUnitType, to toUnitType: HeightUnitType) -> Double
    func convertWithSymbol(value: Double, from fromUnitType: HeightUnitType, to toUnitType: HeightUnitType) -> String
}

protocol WeightUnitLocalizable {
    func convert(value: Double, from fromUnitType: WeightUnitType, to toUnitType: WeightUnitType) -> Double
    func convertWithSymbol(value: Double, from fromUnitType: WeightUnitType, to toUnitType: WeightUnitType) -> String
}

protocol EnergyUnitLocalizable {
    func convert(value: Double, from fromUnitType: EnergyUnitType, to toUnitType: EnergyUnitType) -> Double
    func convertWithSymbol(value: Double, from fromUnitType: EnergyUnitType, to toUnitType: EnergyUnitType) -> String
}

final class UnitLocalizeHelper: HeightUnitLocalizable, WeightUnitLocalizable, EnergyUnitLocalizable {
    static let shared = UnitLocalizeHelper()

    private init() {}

    func convert(value: Double, from fromUnitType: HeightUnitType, to toUnitType: HeightUnitType) -> Double {
        let fromUnit: UnitLength = fromUnitType == .centimeters ? .centimeters : .feet
        let toUnit: UnitLength = toUnitType == .centimeters ? .centimeters : .feet
        return Measurement(value: value, unit: fromUnit).converted(to: toUnit).value
    }

    func convertWithSymbol(value: Double, from fromUnitType: HeightUnitType, to toUnitType: HeightUnitType) -> String {
        "\(Int(convert(value: value, from: fromUnitType, to: toUnitType))) \(toUnitType.unit.symbol)"
    }

    func convert(value: Double, from fromUnitType: WeightUnitType, to toUnitType: WeightUnitType) -> Double {
        let fromUnit: UnitMass = fromUnitType == .kilograms ? .kilograms : .pounds
        let toUnit: UnitMass = toUnitType == .kilograms ? .kilograms : .pounds
        return Measurement(value: value, unit: fromUnit).converted(to: toUnit).value
    }

    func convertWithSymbol(value: Double, from fromUnitType: WeightUnitType, to toUnitType: WeightUnitType) -> String {
        "\(Int(convert(value: value, from: fromUnitType, to: toUnitType))) \(toUnitType.unit.symbol)"
    }

    func convert(value: Double, from fromUnitType: EnergyUnitType, to toUnitType: EnergyUnitType) -> Double {
        let fromUnit: UnitEnergy = fromUnitType == .kilocalories ? .kilocalories : .kilojoules
        let toUnit: UnitEnergy = toUnitType == .kilocalories ? .kilocalories : .kilojoules
        return Measurement(value: value, unit: fromUnit).converted(to: toUnit).value
    }

    func convertWithSymbol(value: Double, from fromUnitType: EnergyUnitType, to toUnitType: EnergyUnitType) -> String {
        "\(Int(convert(value: value, from: fromUnitType, to: toUnitType))) \(toUnitType.unit.symbol)"
    }
}
