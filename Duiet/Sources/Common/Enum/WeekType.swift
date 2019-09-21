//
//  WeekType.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/15.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

enum WeekType: String, CaseIterable {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday

    var abbr: String {
        switch self {
        case .sunday:
            return R.string.localizable.sundayAbbr()

        case .monday:
            return R.string.localizable.mondayAbbr()

        case .tuesday:
            return R.string.localizable.tuesdayAbbr()

        case .wednesday:
            return R.string.localizable.wednesdayAbbr()

        case .thursday:
            return R.string.localizable.thursdayAbbr()

        case .friday:
            return R.string.localizable.fridayAbbr()

        case .saturday:
            return R.string.localizable.saturdayAbbr()
        }
    }
}
