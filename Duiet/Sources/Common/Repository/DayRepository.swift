//
//  DayRepository.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/05.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift

protocol DayRepositoryProtocol {
    func find(meals date: Date) -> Results<Meal>
    func findOrCreate(day date: Date) -> Day
    func findOrCreate(month date: Date) -> Month
    func add(meal: Meal, to day: Day)
    func add(content: Content, to meal: Meal)
    func update(name: String, of content: Content)
    func update(calorie: Double, of content: Content)
    func update(multiple: Double, of content: Content)
    func delete(content: Content, of meal: Meal)
}

final class DayRepository: DayRepositoryProtocol {

    let realm: Realm

    init() {
        realm = try! Realm()
    }

    deinit {
        print("🧹🧹🧹 Day Repository Parge 🧹🧹🧹")
    }

    func find(meals date: Date) -> Results<Meal> {
        let dayStart = Calendar.current.startOfDay(for: date)
        let dayEnd = Date(timeInterval: 60 * 60 * 24, since: dayStart)
        let mealResults = realm.objects(Meal.self)
            .filter("date BETWEEN %@", [dayStart, dayEnd])
            .sorted(byKeyPath: "date")
        return mealResults
    }

    func findOrCreate(day date: Date) -> Day {
        let today = date.toDayKeyString()
        let dayObject = realm.object(ofType: Day.self, forPrimaryKey: today)
        if let _day = dayObject {
            return _day
        } else {
            let _day = Day(date: date)
            let month = findOrCreate(month: date)
            try! realm.write {
                month.days.append(_day)
            }
            return _day
        }
    }

    func findOrCreate(month date: Date) -> Month {
        let thisMonth = date.toMonthKeyString()
        let monthObject = realm.object(ofType: Month.self, forPrimaryKey: thisMonth)
        if let _month = monthObject {
            return _month
        } else {
            let _month = Month(date: date)
            print(_month)
            try! realm.write {
                realm.add(_month)
            }
            return _month
        }
    }

    func add(meal: Meal, to day: Day) {
        try! realm.write {
            day.meals.append(meal)
        }
    }

    func add(content: Content, to meal: Meal) {
        try! realm.write {
            meal.contents.append(content)
        }
    }

    func update(name: String, of content: Content) {
        try! realm.write {
            content.name = name
        }
    }

    func update(calorie: Double, of content: Content) {
        try! realm.write {
            content.calorie = calorie
        }
    }

    func update(multiple: Double, of content: Content) {
        try! realm.write {
            content.multiple = multiple
        }
    }

    func delete(content: Content, of meal: Meal) {
        if let deleteTargetIndex = meal.contents.index(of: content) {
            try! realm.write {
                meal.contents.remove(at: deleteTargetIndex)
                realm.delete(content)
            }
        } else {
            print("Nothing \(content)")
        }
    }
}
