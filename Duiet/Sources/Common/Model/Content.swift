//
//  Content.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/05/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift

final class Content: Object {

    @objc dynamic var name = ""
    @objc dynamic var calorie = 0.0
    @objc dynamic var multiple = 0.0

    @objc dynamic var minX = 0.0
    @objc dynamic var minY = 0.0

    required convenience init(name: String,
                              calorie: Double,
                              multiple: Double) {
        self.init()
        self.name = name
        self.calorie = calorie
        self.multiple = multiple
    }
}
