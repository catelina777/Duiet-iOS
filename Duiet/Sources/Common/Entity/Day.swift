//
//  Day.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/06/26.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift

final class Day: Object {
    @objc dynamic var date = ""
    let meals = List<Meal>()

    @objc dynamic var createdAt = Date()
    @objc dynamic var updatedAt = Date()

    override static func primaryKey() -> String? {
        "date"
    }

    required convenience init(date: Date) {
        self.init()
        self.date = date.toDayKeyString()
        createdAt = date
    }

    var totalCalorie: Double {
        meals.reduce(into: 0) { $0 += $1.totalCalorie }
    }
}
