//
//  BiologicalSexType.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/16.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

enum BiologicalSexType: String {
    case male, female, other

    static func get(_ type: String) -> BiologicalSexType {
        switch type {
        case "male":
            return .male

        case "female":
            return .female

        default:
            return .other
        }
    }
}
