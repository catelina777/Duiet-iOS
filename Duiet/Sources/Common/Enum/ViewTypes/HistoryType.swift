//
//  HistoryType.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/10/25.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

enum HistoryType: String, CaseIterable {
    case today
    case days
    case months

    var title: String {
        switch self {
        case .today:
            return R.string.localizable.today()

        case .days:
            return R.string.localizable.days()

        case .months:
            return R.string.localizable.months()
        }
    }
}
