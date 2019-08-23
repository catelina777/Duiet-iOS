//
//  Month.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/06/27.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift

final class Month: Object {
    @objc dynamic var date = ""
    let days = List<Day>()
    @objc dynamic var createdAt = Date()

    override static func primaryKey() -> String? {
        return "date"
    }

    required convenience init(date: Date) {
        self.init()
        self.date = date.toMonthKeyString()
        self.createdAt = date
    }

    var totalCalories: Double {
        return days.reduce(into: 0) { $0 += $1.totalCalorie }
    }
}
