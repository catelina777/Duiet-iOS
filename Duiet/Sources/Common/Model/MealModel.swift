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

    let changeData: Observable<RealmChangeset?>

    var mealsValue: [Meal] {
        return _meals.value
    }

    let contentDidDelete = PublishRelay<Void>()
    private let _meals = BehaviorRelay<[Meal]>(value: [])
    private let disposeBag = DisposeBag()

    let realm: Realm

    override init() {
        realm = try! Realm()

        let todayStart = Calendar.current.startOfDay(for: .init())
        let todayEnd = Date(timeInterval: 60 * 60 * 24, since: todayStart)
        let mealResults = realm.objects(Meal.self)
            .filter("date BETWEEN %@", [todayStart, todayEnd])
            .sorted(byKeyPath: "date")

        Observable.array(from: mealResults)
            .bind(to: self._meals)
            .disposed(by: self.disposeBag)

        changeData = Observable.changeset(from: mealResults)
            .map { $1 }

        super.init()
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
