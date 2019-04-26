//
//  ActivityLevel.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/19.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

enum ActivityLevel {
    case sedentary
    case lightly
    case moderately
    case veryActive
    case none

    var text: String? {
        switch self {
        case .sedentary:
            return "No exercise"
        case .lightly:
            return "Lightly"
        case .moderately:
            return "Moderately"
        case .veryActive:
            return "Very Active"
        case .none:
            return nil
        }
    }

    var description: String {
        switch self {
        case .sedentary:
            return "No exercise"
        case .lightly:
            return "Light exercise 1-3 days/week"
        case .moderately:
            return "Moderately exercise 3-5 days/week"
        case .veryActive:
            return "Hard exercise 6-7 days/week"
        case .none:
            return "Please Pick from these"
        }
    }

    var magnification: Double {
        switch self {
        case .sedentary:
            return 1.2
        case .lightly:
            return 1.375
        case .moderately:
            return 1.55
        case .veryActive:
            return 1.725
        case .none:
            return 0
        }
    }

    static func getType(with row: Int) -> ActivityLevel {
        switch row {
        case 1:
            return .sedentary
        case 2:
            return .lightly
        case 3:
            return .moderately
        case 4:
            return .veryActive
        default:
            return .none
        }
    }
}
