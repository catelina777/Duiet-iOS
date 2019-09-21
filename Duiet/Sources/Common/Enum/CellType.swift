//
//  CellType.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/04/27.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

enum CellType: String {
    case gender
    case age
    case height
    case weight
    case activityLevel
    case complete

    var title: String {
        switch self {
        case .gender:
            return R.string.localizable.gender()

        case .age:
            return R.string.localizable.age()

        case .height:
            return R.string.localizable.height() + "(" + R.string.localizable.cm() + ")"

        case .weight:
            return R.string.localizable.weight() + "(" + R.string.localizable.kg() + ")"

        case .activityLevel:
            return R.string.localizable.activityLevel()

        case .complete:
            return R.string.localizable.complete()
        }
    }
}
