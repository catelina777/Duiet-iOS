//
//  ProgressType.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/10.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

enum ProgressType {
    case exceed
    case less
    case none

    var color: UIColor {
        let theme = AppAppearance.shared.themeService.attrs
        switch self {
        case .exceed:
            return theme.progressExceedColor

        case .less:
            return theme.progressLessColor

        case .none:
            return theme.progressNoneColor
        }
    }

    static func get(by number: Int) -> ProgressType {
        switch number {
        case 0:
            return .none

        case 1:
            return .exceed

        case 2:
            return .less

        default:
            return .none
        }
    }
}
