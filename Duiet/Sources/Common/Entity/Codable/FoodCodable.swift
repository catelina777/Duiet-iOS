//
//  FoodCodable.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/25.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

struct FoodCodable: Codable {
    var id: String
    var name: String
    var calorie: Double
    var multiple: Double
    var relativeX: Double
    var relativeY: Double
    var createdAt: Date
    var updatedAt: Date
    var mealId: String
}
