//
//  Body.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/09/28.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import HealthKit

struct Body: CalorieCalcable {
    let biologicalSex: HKBiologicalSex?
    let age: Int?
    let height: Double?
    let weight: Double?
    let activityLevel: ActivityLevelType
}
