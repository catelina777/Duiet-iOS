//
//  UnitType.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/10/14.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

protocol UnitType {
    var abbr: String { get }
    var unit: Unit { get }
    var row: Int { get }

    static func get(_ row: Int) -> UnitType
}
