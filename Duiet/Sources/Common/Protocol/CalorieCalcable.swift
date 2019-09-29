//
//  CalorieCalcable.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/09/28.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import HealthKit

protocol CalorieCalcable {
    func BMR(body: Body) -> Double
    func TDEE(body: Body) -> Double
}

extension CalorieCalcable {
    func BMR(body: Body) -> Double {
        let height = body.height ?? 170
        let weight = body.weight ?? 65
        let age = Double(body.age ?? 30)
        let biologicalSex = body.biologicalSex ?? .notSet
        return height * 6.25 + weight * 9.99 - age * 4.92 + getVariable(of: biologicalSex)
    }

    func TDEE(body: Body) -> Double {
        BMR(body: body) * body.activityLevel.magnification
    }

    private func getVariable(of biologicalSex: HKBiologicalSex) -> Double {
        biologicalSex == .female ? -161 : 5
    }
}
