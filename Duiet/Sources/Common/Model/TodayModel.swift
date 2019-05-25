//
//  TodayModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/05/25.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RealmSwift

class TodayModel {

    let meals: Observable<[Meal]>

    var mealsValue: [Meal] {
        return _meals.value
    }

    private let _meals = BehaviorRelay<[Meal]>(value: [])

    private let disposeBag = DisposeBag()

    init() {
        let todayStart = Calendar.current.startOfDay(for: .init())
        let todayEnd = Date(timeInterval: 60 * 60 * 24, since: todayStart)
        let realm = try! Realm()
        let meals = realm.objects(Meal.self).filter("date BETWEEN %@", [todayStart, todayEnd])
        self.meals = _meals.asObservable()
        Observable.array(from: meals)
            .bind(to: _meals)
            .disposed(by: disposeBag)
    }
}
