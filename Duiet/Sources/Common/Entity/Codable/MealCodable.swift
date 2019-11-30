//
//  MealCodable.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/25.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

struct MealCodable: Codable {
    var id: String
    var imageId: String
    var createdAt: Date
    var updatedAt: Date
    var dayId: String
    var foodIds: [String]
}
