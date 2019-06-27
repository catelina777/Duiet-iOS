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
        switch self {
        case .exceed:
            return #colorLiteral(red: 0.9333333333, green: 0.3411764706, blue: 0.5294117647, alpha: 1)
        case .less:
            return #colorLiteral(red: 0.2509803922, green: 0.5215686275, blue: 0.8705882353, alpha: 1)
        case .none:
            return #colorLiteral(red: 0.9058823529, green: 0.9098039216, blue: 0.9137254902, alpha: 1)
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
