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

final class MealModel: NSObject {

    let changeData = PublishRelay<RealmChangeset?>()
    let contentDidDelete = PublishRelay<Void>()
    let meals = BehaviorRelay<[Meal]>(value: [])
    fileprivate let day = BehaviorRelay<Day>(value: Day(date: Date()))
    private let disposeBag = DisposeBag()

    fileprivate let realm: Realm

    override init() {
        realm = try! Realm()
        super.init()

        let now = Date()
        let day = find(day: now)
        accept(day: day)

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

    /// Get the day model, and create and save a new day model if it does not exist
    private func find(day: Date) -> Day {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let today = dateFormatter.string(from: day)
        let dayObject = realm.object(ofType: Day.self, forPrimaryKey: today)
        if let _day = dayObject {
            return _day
        } else {
            let _day = Day(date: day)
            try! realm.write {
                realm.add(_day)
            }
            return _day
        }
    }

    private func accept(day: Day) {
        self.day.accept(day)
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
