//
//  PageType.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/08.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

enum PageType: String {
    case fillInfomation
    case inputMeal
    case calculate

    var title: String {
        switch self {
        case .calculate:
            return R.string.localizable.calculate()
        default:
            return self.rawValue
        }
    }
}
