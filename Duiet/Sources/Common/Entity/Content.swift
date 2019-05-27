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

    @objc dynamic var relativeX = 0.0
    @objc dynamic var relativeY = 0.0

    required convenience init(relativeX: Double, relativeY: Double) {
        self.init()
        self.relativeX = relativeX
        self.relativeY = relativeY
    }
}
