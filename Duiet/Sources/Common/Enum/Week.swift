//
//  Week.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/15.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

enum Week: String {
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
            return "S"
        case .monday:
            return "M"
        case .tuesday:
            return "T"
        case .wednesday:
            return "W"
        case .thursday:
            return "T"
        case .friday:
            return "F"
        case .saturday:
            return "S"
        }
    }

    static let all: [Week] = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
}
