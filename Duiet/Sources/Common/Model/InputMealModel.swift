//
//  InputMealModel.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/07/11.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRelay
import RxCocoa
import RxRealm

protocol InputMealModelProtocol {
    var contentDidAdd: PublishRelay<Void> { get }
    var contentDidUpdate: PublishRelay<Content> { get }
    var contentDidDelete: PublishRelay<Void> { get }
    var meal: BehaviorRelay<Meal> { get }
    var meals: PublishRelay<[Meal]> { get }
    var day: BehaviorRelay<Day> { get }
    var addMeal: Binder<Meal> { get }
    var addContent: Binder<(Meal, Content)> { get }
    var saveName: Binder<(Content, String)> { get }
    var saveCalorie: Binder<(Content, Double)> { get }
    var saveMultiple: Binder<(Content, Double)> { get }
    var deleteContent: Binder<(Meal, Content)> { get }
}

final class InputMealModel: InputMealModelProtocol {

    let contentDidAdd = PublishRelay<Void>()
    let contentDidUpdate = PublishRelay<Content>()
    let contentDidDelete = PublishRelay<Void>()
    let meal: BehaviorRelay<Meal>
    let meals = PublishRelay<[Meal]>()
    let day = BehaviorRelay<Day>(value: Day(date: Date()))

    private let repository: DayRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(date: Date = Date(),
         repository: DayRepositoryProtocol,
         meal: Meal) {
        self.repository = repository
        self.meal = BehaviorRelay<Meal>(value: meal)
    }

    deinit {
        print("🧹🧹🧹 InputMealModel Parge 🧹🧹🧹")
    }

    var addMeal: Binder<Meal> {
        return Binder(self) { me, meal in
            me.repository.add(meal: meal, to: me.day.value)
        }
    }

    var addContent: Binder<(Meal, Content)> {
        return Binder(self) { me, tuple in
            me.repository.add(content: tuple.1, to: tuple.0)
            me.contentDidAdd.accept(())
        }
    }

    var saveName: Binder<(Content, String)> {
        return Binder(self) { me, tuple in
            let content = tuple.0
            guard !content.isInvalidated else { return }
            me.repository.update(name: tuple.1, of: content)
            me.contentDidUpdate.accept(content)
        }
    }

    var saveCalorie: Binder<(Content, Double)> {
        return Binder(self) { me, tuple in
            let content = tuple.0
            guard !content.isInvalidated else { return }
            me.repository.update(calorie: tuple.1, of: content)
            me.contentDidUpdate.accept(content)
        }
    }

    var saveMultiple: Binder<(Content, Double)> {
        return Binder(self) { me, tuple in
            let content = tuple.0
            guard !content.isInvalidated else { return }
            me.repository.update(multiple: tuple.1, of: content)
            me.contentDidUpdate.accept(content)
        }
    }

    var deleteContent: Binder<(Meal, Content)> {
        return Binder(self) { me, tuple in
            let content = tuple.1
            guard !content.isInvalidated else { return }
            me.repository.delete(content: tuple.1, of: tuple.0)
            me.contentDidDelete.accept(())
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

    private func observe(mealResults: Results<Meal>) {
        Observable.array(from: mealResults)
            .subscribe(onNext: { [weak self] meals in
                guard let self = self else { return }
                self.meals.accept(meals)
            })
            .disposed(by: self.disposeBag)
    }
}
