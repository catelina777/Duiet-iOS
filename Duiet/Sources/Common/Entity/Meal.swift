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
    @objc dynamic var date = Date()

    required convenience init(imagePath: String) {
        self.init()
        self.imagePath = imagePath
    }
}
