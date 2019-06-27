//
//  UserInfo.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/05/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift

final class UserInfo: Object {

    @objc dynamic var id = 0
    @objc dynamic var gender = false
    @objc dynamic var age = 0
    @objc dynamic var height = 0.0
    @objc dynamic var weight = 0.0
    @objc dynamic var activityLevel = 0

    required convenience init(gender: Bool,
                              age: Int,
                              height: Double,
                              weight: Double,
                              activityLevel: ActivityLevel) {
        self.init()
        self.gender = gender
        self.age = age
        self.height = height
        self.weight = weight
        self.activityLevel = activityLevel.row
    }

    override static func primaryKey() -> String? {
        return "id"
    }

    var BMR: Double {
        return calculate()
    }

    var TDEE: Double {
        let activityLevel = ActivityLevel.getType(with: self.activityLevel)
        return calculate() * activityLevel.magnification
    }

    private func calculate() -> Double {
        return (height * 6.25) + (weight * 9.99) - (Double(age) * 4.92) + genderVariable(with: gender)
    }

    private func genderVariable(with gender: Bool) -> Double {
        return gender ? 5 : -161
    }
}
