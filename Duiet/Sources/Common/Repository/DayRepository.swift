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
    func delete(meal: Meal, of day: Day)
    func delete(meals: [Meal], of day: Day)
}

final class DayRepository: DayRepositoryProtocol {
    static let shared = DayRepository()

    private let realm: Realm

    private init() {
        realm = try! Realm()
    }

    func find(meals date: Date) -> Results<Meal> {
        let dayStart = Calendar.current.startOfDay(for: date)
        let dayEnd = Date(timeInterval: 60 * 60 * 24, since: dayStart)
        let mealResults = realm.objects(Meal.self)
            .filter("createdAt BETWEEN %@", [dayStart, dayEnd])
            .sorted(byKeyPath: "createdAt")
        return mealResults
    }

    func findOrCreate(day date: Date) -> Day {
        let today = date.toDayKeyString()
        let dayObject = realm.object(ofType: Day.self, forPrimaryKey: today)
        if let day = dayObject {
            return day
        } else {
            let day = Day(date: date)
            let month = findOrCreate(month: date)
            try! realm.write {
                month.days.append(day)
                month.updatedAt = Date()
            }
            return day
        }
    }

    func findOrCreate(month date: Date) -> Month {
        let thisMonth = date.toMonthKeyString()
        let monthObject = realm.object(ofType: Month.self, forPrimaryKey: thisMonth)
        if let month = monthObject {
            return month
        } else {
            let month = Month(date: date)
            try! realm.write {
                realm.add(month)
            }
            return month
        }
    }

    func add(meal: Meal, to day: Day) {
        try! realm.write {
            day.meals.append(meal)
            day.updatedAt = Date()
        }
    }

    func add(content: Content, to meal: Meal) {
        try! realm.write {
            meal.contents.append(content)
            meal.updatedAt = Date()
        }
    }

    func update(name: String, of content: Content) {
        try! realm.write {
            content.name = name
            content.updatedAt = Date()
        }
    }

    func update(calorie: Double, of content: Content) {
        try! realm.write {
            content.calorie = calorie
            content.updatedAt = Date()
        }
    }

    func update(multiple: Double, of content: Content) {
        try! realm.write {
            content.multiple = multiple
            content.updatedAt = Date()
        }
    }

    func delete(content: Content, of meal: Meal) {
        if let deleteTargetIndex = meal.contents.index(of: content) {
            try! realm.write {
                meal.contents.remove(at: deleteTargetIndex)
                realm.delete(content)
                meal.updatedAt = Date()
            }
        } else {
            Logger.shared.error("Nothing \(content)")
        }
    }

    func delete(meal: Meal, of day: Day) {
        if let deleteTargetIndex = day.meals.index(of: meal) {
            try! realm.write {
                day.meals.forEach {
                    realm.delete($0.contents)
                }
                day.meals.remove(at: deleteTargetIndex)
                realm.delete(meal)
                day.updatedAt = Date()
            }
        } else {
            Logger.shared.error("Nothing \(meal)")
        }
    }

    func delete(meals: [Meal], of day: Day) {
        meals.forEach { meal in
            delete(meal: meal, of: day)
        }
    }
}
