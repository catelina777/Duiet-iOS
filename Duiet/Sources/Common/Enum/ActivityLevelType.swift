//
//  ActivityLevelType.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/19.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

enum ActivityLevelType: CaseIterable {
    case none
    case sedentary
    case lightly
    case moderately
    case veryActive

    var text: String? {
        switch self {
        case .sedentary:
            return R.string.localizable.sedentaryText()

        case .lightly:
            return R.string.localizable.lightlyText()

        case .moderately:
            return R.string.localizable.moderatelyText()

        case .veryActive:
            return R.string.localizable.veryActiveText()

        case .none:
            return nil
        }
    }

    var description: String {
        switch self {
        case .sedentary:
            return R.string.localizable.sedentaryDescription()

        case .lightly:
            return R.string.localizable.lightlyDescription()

        case .moderately:
            return R.string.localizable.moderatelyDescription()

        case .veryActive:
            return R.string.localizable.veryActiveDescription()

        case .none:
            return R.string.localizable.noneDescription()
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

    static func get(_ row: Int) -> ActivityLevelType {
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

    var row: Int {
        switch self {
        case .sedentary:
            return 1

        case .lightly:
            return 2

        case .moderately:
            return 3

        case .veryActive:
            return 4

        case .none:
            return 0
        }
    }
}
