//
//  UnitBabel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/10/19.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

protocol HeightUnitLocalizable {
    /// Convert a unit of height
    /// - Parameter value: The value to convert
    /// - Parameter fromUnit: Unit before conversion
    /// - Parameter toUnit: Unit after conversion
    func convert(value: Double, from fromUnit: HeightUnitType, to toUnit: HeightUnitType) -> Double

    /// Convert a unit of height and give it a unit symbol. In the case of feet, the value including the decimal point is output.
    /// - Parameter value: The value to convert
    /// - Parameter fromUnit: Unit before conversion
    /// - Parameter toUnit: Unit after conversion
    func convertWithSymbol(value: Double, from fromUnit: HeightUnitType, to toUnit: HeightUnitType) -> String
}

protocol WeightUnitLocalizable {
    /// Convert a unit of height
    /// - Parameter value: The value to convert
    /// - Parameter fromUnit: Unit before conversion
    /// - Parameter toUnit: Unit after conversion
    func convert(value: Double, from fromUnit: WeightUnitType, to toUnit: WeightUnitType) -> Double

    /// Convert a unit of height and give it a unit symbol. A small number of values are rounded.
    /// - Parameter value: The value to convert
    /// - Parameter fromUnit: Unit before conversion
    /// - Parameter toUnitType: Unit after conversion
    func convertWithSymbol(value: Double, from fromUnit: WeightUnitType, to toUnit: WeightUnitType) -> String

    /// Convert a unit of height and give it a unit symbol. The value is displayed to the third decimal place.
    /// - Parameter value: The value to convert
    /// - Parameter fromUnit: Unit before conversion
    /// - Parameter toUnit: Unit after conversion
    /// - Parameter significantDigits: Significant digits
    func convertRoundedWithSymbol(value: Double, from fromUnit: WeightUnitType, to toUnit: WeightUnitType, significantDigits: Double) -> String
}

protocol EnergyUnitLocalizable {
    /// Convert a unit of height
    /// - Parameter value: The value to convert
    /// - Parameter fromUnitType: Unit before conversion
    /// - Parameter toUnitType: Unit after conversion
    func convert(value: Double, from fromUnitType: EnergyUnitType, to toUnitType: EnergyUnitType) -> Double

    /// Convert a unit of height and give it a unit symbol. A small number of values are rounded.
    /// - Parameter value: The value to convert
    /// - Parameter fromUnitType: Unit before conversion
    /// - Parameter toUnitType: Unit after conversion
    func convertWithSymbol(value: Double, from fromUnitType: EnergyUnitType, to toUnitType: EnergyUnitType) -> String
}

final class UnitBabel: HeightUnitLocalizable, WeightUnitLocalizable, EnergyUnitLocalizable {
    static let shared = UnitBabel()

    private init() {}

    func convert(value: Double, from fromUnit: HeightUnitType, to toUnit: HeightUnitType) -> Double {
        let fromUnit: UnitLength = fromUnit == .centimeters ? .centimeters : .feet
        let toUnit: UnitLength = toUnit == .centimeters ? .centimeters : .feet
        return Measurement(value: value, unit: fromUnit).converted(to: toUnit).value
    }

    func convertWithSymbol(value: Double, from fromUnit: HeightUnitType, to toUnit: HeightUnitType) -> String {
        if toUnit == .centimeters {
            return "\(Int(convert(value: value, from: fromUnit, to: toUnit))) \(toUnit.symbol)"
        }
        let convertedValue = convert(value: value, from: fromUnit, to: toUnit)
        return "\(abs(round(convertedValue * 1_000) / 1_000)) \(toUnit.symbol)"
    }

    func convert(value: Double, from fromUnit: WeightUnitType, to toUnit: WeightUnitType) -> Double {
        let fromUnit: UnitMass = fromUnit == .kilograms ? .kilograms : .pounds
        let toUnit: UnitMass = toUnit == .kilograms ? .kilograms : .pounds
        return Measurement(value: value, unit: fromUnit).converted(to: toUnit).value
    }

    func convertWithSymbol(value: Double, from fromUnitType: WeightUnitType, to toUnitType: WeightUnitType) -> String {
        "\(Int(convert(value: value, from: fromUnitType, to: toUnitType))) \(toUnitType.symbol)"
    }

    func convertRoundedWithSymbol(value: Double, from fromUnit: WeightUnitType, to toUnit: WeightUnitType, significantDigits: Double) -> String {
        let convertedValue = convert(value: value, from: fromUnit, to: toUnit)
        let power = pow(10, significantDigits)
        return "\(abs(round(convertedValue * power) / power)) \(toUnit.symbol)"
    }

    func convert(value: Double, from fromUnit: EnergyUnitType, to toUnit: EnergyUnitType) -> Double {
        let fromUnit: UnitEnergy = fromUnit == .kilocalories ? .kilocalories : .kilojoules
        let toUnit: UnitEnergy = toUnit == .kilocalories ? .kilocalories : .kilojoules
        return Measurement(value: value, unit: fromUnit).converted(to: toUnit).value
    }

    func convertWithSymbol(value: Double, from fromUnitType: EnergyUnitType, to toUnitType: EnergyUnitType) -> String {
        "\(Int(convert(value: value, from: fromUnitType, to: toUnitType))) \(toUnitType.symbol)"
    }
}
