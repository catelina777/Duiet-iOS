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

    @objc dynamic var date = "aaa"
    let meals = List<Meal>()

    override static func primaryKey() -> String? {
        return "date"
    }

    required convenience init(date: Date) {
        self.init()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        self.date = dateFormatter.string(from: date)
    }
}
