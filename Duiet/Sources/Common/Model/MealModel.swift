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

    let meals: Observable<[Meal]>
    let changeData: Observable<RealmChangeset?>

    var mealsValue: [Meal] {
        return _meals.value
    }

    private let _meals = BehaviorRelay<[Meal]>(value: [])
    private let disposeBag = DisposeBag()

    let realm: Realm

    override init() {
        realm = try! Realm()
        self.meals = _meals.asObservable()

        let todayStart = Calendar.current.startOfDay(for: .init())
        let todayEnd = Date(timeInterval: 60 * 60 * 24, since: todayStart)
        let meals = realm.objects(Meal.self).filter("date BETWEEN %@", [todayStart, todayEnd]).sorted(byKeyPath: "date")
        Observable.array(from: meals)
            .bind(to: self._meals)
            .disposed(by: self.disposeBag)

        changeData = Observable.changeset(from: meals)
            .map { $1 }

        super.init()
    }

    private func findToday() {
        let todayStart = Calendar.current.startOfDay(for: .init())
        let todayEnd = Date(timeInterval: 60 * 60 * 24, since: todayStart)
        let meals = realm.objects(Meal.self).filter("date BETWEEN %@", [todayStart, todayEnd]).sorted(byKeyPath: "date")
        Observable.array(from: meals)
            .bind(to: self._meals)
            .disposed(by: self.disposeBag)
    }
}

extension Reactive where Base: MealModel {

    var addMeal: Binder<Meal> {
        return Binder(base) { me, meal in
            try! me.realm.write {
                me.realm.add(meal)
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

    var saveName: Binder<(Content, String)> {
        return Binder(base) { me, tuple in
            try! me.realm.write {
                tuple.0.name = tuple.1
            }
        }
    }

    var saveCalorie: Binder<(Content, Double)> {
        return Binder(base) { me, tuple in
            try! me.realm.write {
                tuple.0.calorie = tuple.1
            }
        }
    }

    var saveMultiple: Binder<(Content, Double)> {
        return Binder(base) { me, tuple in
            try! me.realm.write {
                tuple.0.multiple = tuple.1
            }
        }
    }
}
