//
//  DayCodable.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/25.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

struct DayCodable: Codable {
    var id: String
    var date: String
    var createdAt: Date
    var updatedAt: Date
    var meals: [MealCodable]
}
