//
//  SeedManager.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/06/28.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift

class SeedManager {

    let realm: Realm

    init() {
        realm = try! Realm()
    }

    func generate() {
        try! realm.write {
            realm.deleteAll()
        }
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        let years = [2017, 2018, 2019]
        let months = [1, 2, 3, 4, 5, 7, 9, 10, 11, 12]
        let days = [1, 2, 3, 4, 5, 6, 8, 10, 13, 15, 16, 17, 20, 25, 27, 29]

        years.forEach { year in
            dateComponents.year = year
            months.forEach { month in
                dateComponents.month = month
                dateComponents.day = 1
                let date = calendar.date(from: dateComponents)!
                let monthObject = Month(date: date)
                days.forEach { day in
                    dateComponents.day = day
                    let date = calendar.date(from: dateComponents)!
                    let dayObject = Day(date: date)
                    let meal1 = Meal(date: date)
                    let meal2 = Meal(date: date)
                    let meal3 = Meal(date: date)
                    let content1 = createContent()
                    meal1.contents.append(content1)
                    meal2.contents.append(content1)
                    meal3.contents.append(content1)
                    dayObject.meals.append(meal1)
                    dayObject.meals.append(meal2)
                    dayObject.meals.append(meal3)
                    monthObject.days.append(dayObject)
                }
                try! realm.write {
                    realm.add(monthObject, update: .all)
                }
            }
        }
        let userInfo = UserInfo(gender: true,
                                age: 22,
                                height: 167,
                                weight: 61.5,
                                activityLevel: .lightly)
        try! realm.write {
            realm.add(userInfo, update: .all)
        }

        let key = "isLaunchedBefore"
        UserDefaults.standard.set(true, forKey: key)
    }

    func createContent() -> Content {
        let content = Content(relativeX: Double.random(in: 0..<200),
                              relativeY: Double.random(in: 0..<200))
        content.calorie = Double.random(in: 400..<800)
        content.multiple = Double.random(in: 0.5..<2)
        return content
    }
}
