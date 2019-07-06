//
//  DayModel.swift
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

protocol DayModelProtocol {
    var changeData: PublishRelay<RealmChangeset?> { get }
    var contentDidDelete: PublishRelay<Void> { get }
    var meals: BehaviorRelay<[Meal]> { get }
    var day: BehaviorRelay<Day> { get }
    var addMeal: Binder<Meal> { get }
    var addContent: Binder<(Meal, Content)> { get }
    var saveName: Binder<(MealLabelView, String)> { get }
    var saveCalorie: Binder<(MealLabelView, Double)> { get }
    var saveMultiple: Binder<(MealLabelView, Double)> { get }
    var deleteContent: Binder<(Meal, Content)> { get }
}

final class DayModel: RealmBaseModel, DayModelProtocol {

    let changeData = PublishRelay<RealmChangeset?>()
    let contentDidDelete = PublishRelay<Void>()
    let meals = BehaviorRelay<[Meal]>(value: [])
    let day = BehaviorRelay<Day>(value: Day(date: Date()))

    private let repository: DayRepositoryProtocol

    init(date: Date = Date(),
         repository: DayRepositoryProtocol) {
        self.repository = repository
        super.init()

        let day = repository.findOrCreate(day: date)
        observe(day: day)

        let mealResults = repository.find(meals: date)
        observe(mealResults: mealResults)
        observe(mealResultsChangeset: mealResults)
    }

    deinit {
        print("🧹🧹🧹 Day Model Parge 🧹🧹🧹")
    }

    var addMeal: Binder<Meal> {
        return Binder(self) { me, meal in
            me.repository.add(meal: meal, to: me.day.value)
        }
    }

    var addContent: Binder<(Meal, Content)> {
        return Binder(self) { me, tuple in
            me.repository.add(content: tuple.1, to: tuple.0)
        }
    }

    var saveName: Binder<(MealLabelView, String)> {
        return Binder(self) { me, tuple in
            let content = tuple.0.content.value
            me.repository.update(name: tuple.1, of: content)
            tuple.0.content.accept(content)
        }
    }

    var saveCalorie: Binder<(MealLabelView, Double)> {
        return Binder(self) { me, tuple in
            let content = tuple.0.content.value
            me.repository.update(calorie: tuple.1, of: content)
            tuple.0.content.accept(content)
        }
    }

    var saveMultiple: Binder<(MealLabelView, Double)> {
        return Binder(self) { me, tuple in
            let content = tuple.0.content.value
            me.repository.update(multiple: tuple.1, of: content)
            tuple.0.content.accept(content)
        }
    }

    var deleteContent: Binder<(Meal, Content)> {
        return Binder(self) { me, tuple in
            me.repository.delete(content: tuple.1, of: tuple.0)
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
