//
//  Content.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/05/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RealmSwift

final class Content: Object {

    @objc dynamic var name = ""
    @objc dynamic var calorie = 0.0
    @objc dynamic var multiple = 0.0

    @objc dynamic var relativeX = 0.0
    @objc dynamic var relativeY = 0.0

    @objc dynamic var date = Date()

    required convenience init(relativeX: Double, relativeY: Double) {
        self.init()
        self.relativeX = relativeX
        self.relativeY = relativeY
    }
}

extension Content {

    func convert() -> MealLabelView {
        let mealLabelView = R.nib.mealLabelView.firstView(owner: nil)!
        mealLabelView.configure(with: self)
        return mealLabelView
    }
}

extension List where Element == Content {

    func convert() -> [MealLabelView] {
        return self.map { $0.convert() }
    }
}
