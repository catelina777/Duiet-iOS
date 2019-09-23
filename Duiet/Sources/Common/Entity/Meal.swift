//
//  Meal.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/05/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift

final class Meal: Object {
    @objc dynamic var imagePath = ""
    let contents = List<Content>()

    @objc dynamic var createdAt = Date()
    @objc dynamic var updatedAt = Date()

    required convenience init(imagePath: String, date: Date) {
        self.init()
        self.imagePath = imagePath
        createdAt = date
    }

    #if DEBUG
    required convenience init(date: Date) {
        self.init()
        createdAt = date
    }
    #endif

    var totalCalorie: Double {
        contents.reduce(into: 0) {
            $0 += $1.calorie * ($1.multiple == 0 ? 1 : $1.multiple)
        }
    }
}
