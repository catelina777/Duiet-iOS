//
//  MonthCodable.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/25.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

struct MonthCodable: Codable {
    var id: String
    var date: String
    var createdAt: Date
    var updatedAt: Date
    var dayIds: [String]
}
