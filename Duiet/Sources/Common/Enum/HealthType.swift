//
//  HealthType.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/09/27.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import HealthKit

/// Items want to get and update with HealthKit
enum HealthType {
    case dateOfBirth
    case biologicalSex
    case bodyMass
    case height


    /// Returns a objectType value
    var object: HKObjectType {
        switch self {
        case .dateOfBirth:
            return HKCharacteristicType.characteristicType(forIdentifier: .dateOfBirth)!

        case .biologicalSex:
            return HKCharacteristicType.characteristicType(forIdentifier: .biologicalSex)!

        case .bodyMass:
            return HKQuantityType.quantityType(forIdentifier: .bodyMass)!

        case .height:
            return HKQuantityType.quantityType(forIdentifier: .height)!
        }
    }

    /// Returns a non-nil quantity value for bodyMass or height
    var quantity: HKQuantityType? {
        switch self {
        case .bodyMass:
            return HKQuantityType.quantityType(forIdentifier: .bodyMass)!

        case .height:
            return HKQuantityType.quantityType(forIdentifier: .height)!

        default:
            return nil
        }
    }
}
