//
//  TodayModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/05/25.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift
import RxCocoa
import RxRealm
import RxRelay
import RxSwift

protocol TodayModelProtocol {
    var changeData: PublishRelay<RealmChangeset?> { get }
    var contentDidDelete: PublishRelay<Void> { get }
    var day: BehaviorRelay<Day> { get }
    var meals: [Meal] { get }
    var addMeal: Binder<Meal> { get }
    var title: String { get }
    var date: Date { get }

    func loadMealData(date: Date)
}

final class TodayModel: TodayModelProtocol {
    let changeData = PublishRelay<RealmChangeset?>()
    let contentDidDelete = PublishRelay<Void>()
    let day: BehaviorRelay<Day>
    private let _meals = BehaviorRelay<[Meal]>(value: [])
    private let _mealResults = PublishRelay<Results<Meal>>()

    var meals: [Meal] {
        return _meals.value
    }

    lazy var title: String = {
        let now = Date()
        let date = day.value.createdAt
        let different = Calendar.current.dateComponents([.day], from: date, to: now).day
        if different == 0 {
            return SceneType.today.title
        } else {
            return  date.toString()
        }
    }()

    var date: Date {
        return day.value.createdAt
    }

    private let repository: DayRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(repository: DayRepositoryProtocol = DayRepository.shared,
         date: Date = Date()) {
        self.repository = repository
        day = BehaviorRelay<Day>(value: .init(date: date))

        /// Use the difference of the meal model to detect changes in child elements of the day model
        changeData.withLatestFrom(day)
            .bind(to: day)
            .disposed(by: disposeBag)

        /// Detect change of meals
        _mealResults
            .flatMapLatest { Observable.array(from: $0) }
            .bind(to: _meals)
            .disposed(by: disposeBag)

        /// Detect changes in meals difference
        _mealResults
            .flatMapLatest { Observable.changeset(from: $0) }
            .map { $1 }
            .bind(to: changeData)
            .disposed(by: disposeBag)

        loadMealData(date: date)
    }

    deinit {
        print("🧹🧹🧹 Day Model Parge 🧹🧹🧹")
    }

    var addMeal: Binder<Meal> {
        return Binder(self) { me, meal in
            me.repository.add(meal: meal, to: me.day.value)
        }
    }

    func loadMealData(date: Date) {
        let dayObject = repository.findOrCreate(day: date)
        day.accept(dayObject)

        let mealResults = repository.find(meals: date)
        _mealResults.accept(mealResults)
    }
}
