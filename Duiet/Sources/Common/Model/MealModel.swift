//
//  MealModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/05/25.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import RealmSwift
import RxRealm

final class MealModel: RealmBaseModel {

    static let shared = MealModel()

    let changeData = PublishRelay<RealmChangeset?>()
    let contentDidDelete = PublishRelay<Void>()
    let meals = BehaviorRelay<[Meal]>(value: [])
    let day = BehaviorRelay<Day>(value: Day(date: Date()))

    override init() {
        super.init()

        let now = Date()

        let day = find(day: now)
        observe(day: day)

        let mealResults = find()
        observe(mealResults: mealResults)
        observe(mealResultsChangeset: mealResults)
    }

    private func find() -> Results<Meal> {
        let todayStart = Calendar.current.startOfDay(for: .init())
        let todayEnd = Date(timeInterval: 60 * 60 * 24, since: todayStart)
        let mealResults = realm.objects(Meal.self)
            .filter("date BETWEEN %@", [todayStart, todayEnd])
            .sorted(byKeyPath: "date")
        return mealResults
    }

    /// Get the day model. Create a new day model if it does not exist
    private func find(day date: Date) -> Day {
        let today = date.toDayKeyString()
        let dayObject = realm.object(ofType: Day.self, forPrimaryKey: today)
        if let _day = dayObject {
            return _day
        } else {
            let _day = Day(date: date)
            let month = find(month: date)
            try! realm.write {
                month.days.append(_day)
            }
            return _day
        }
    }

    /// Get the month model. Create a new month model if it does not exist
    private func find(month date: Date) -> Month {
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

    private func observe(day: Day) {
        Observable.from(object: day)
            .subscribe(onNext: { [weak self] day in
                guard let self = self else { return }
                self.day.accept(day)
            })
            .disposed(by: disposeBag)
    }

    private func observe(mealResultsChangeset mealResults: Results<Meal>) {
        Observable.changeset(from: mealResults)
            .map { $1 }
            .subscribe(onNext: { [weak self] changeset in
                guard let self = self else { return }
                self.changeData.accept(changeset)
            })
            .disposed(by: disposeBag)
    }

    private func observe(mealResults: Results<Meal>) {
        Observable.array(from: mealResults)
            .subscribe(onNext: { [weak self] meals in
                guard let self = self else { return }
                self.meals.accept(meals)
            })
            .disposed(by: self.disposeBag)
    }
}

extension Reactive where Base: MealModel {

    var addMeal: Binder<Meal> {
        return Binder(base) { me, meal in
            try! me.realm.write {
                me.day.value.meals.append(meal)
            }
        }
    }

    var addContent: Binder<(Meal, Content)> {
        return Binder(base) { me, tuple in
            try! me.realm.write {
                tuple.0.contents.append(tuple.1)
            }
        }
    }

    var saveName: Binder<(MealLabelView, String)> {
        return Binder(base) { me, tuple in
            try! me.realm.write {
                let content = tuple.0.content.value
                content.name = tuple.1
                tuple.0.content.accept(content)
            }
        }
    }

    var saveCalorie: Binder<(MealLabelView, Double)> {
        return Binder(base) { me, tuple in
            try! me.realm.write {
                let content = tuple.0.content.value
                content.calorie = tuple.1
                tuple.0.content.accept(content)
            }
        }
    }

    var saveMultiple: Binder<(MealLabelView, Double)> {
        return Binder(base) { me, tuple in
            try! me.realm.write {
                let content = tuple.0.content.value
                content.multiple = tuple.1
                tuple.0.content.accept(content)
            }
        }
    }

    var deleteContent: Binder<(Meal, Content)> {
        return Binder(base) { me, tuple in
            if let deleteTargetIndex = tuple.0.contents.index(of: tuple.1) {
                try! me.realm.write {
                    tuple.0.contents.remove(at: deleteTargetIndex)
                    me.realm.delete(tuple.1)
                }
                me.contentDidDelete.accept(())
            } else {
                print("nothing \(tuple.1)")
            }
        }
    }
}
