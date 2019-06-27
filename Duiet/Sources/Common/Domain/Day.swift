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

    override static func primaryKey() -> String? {
        return "date"
    }

    required convenience init(date: Date) {
        self.init()
        self.date = date.toKeyString()
        self.createdAt = date
    }

    var totalCalorie: Double {
        return meals.reduce(into: 0) { $0 += $1.totalCalorie }
    }
}
