//
//  InputMealModel.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/07/11.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift
import RxCocoa
import RxRealm
import RxRelay
import RxSwift

protocol InputMealModelInput {}

protocol InputMealModelOutput {
    var contentDidAdd: Observable<Void> { get }
    var contentDidDelete: Observable<Void> { get }
    var contentDidUpdate: Observable<Content> { get }
    var day: Observable<Day> { get }
    var meal: Observable<Meal> { get }
}

protocol InputMealModelState {
    var mealValue: Meal { get }
    var addContent: Binder<(Meal, Content)> { get }
    var updateContent: Binder<(Content, Content)> { get }
    var saveName: Binder<(Content, String)> { get }
    var saveCalorie: Binder<(Content, Double)> { get }
    var saveMultiple: Binder<(Content, Double)> { get }
    var deleteContent: Binder<(Meal, Content)> { get }
}

protocol InputMealModelProtocol {
    var input: InputMealModelInput { get }
    var output: InputMealModelOutput { get }
    var state: InputMealModelState { get }
}

internal final class InputMealModel: InputMealModelProtocol, InputMealModelState {
    let input: InputMealModelInput
    let output: InputMealModelOutput
    var state: InputMealModelState { self }

    private let contentDidAdd = PublishRelay<Void>()
    private let contentDidUpdate = PublishRelay<Content>()
    private let contentDidDelete = PublishRelay<Void>()
    private let meal: BehaviorRelay<Meal>
    private let day = BehaviorRelay<Day>(value: Day(date: Date()))

    // MARK: State
    var mealValue: Meal {
        meal.value
    }

    private let repository: DayRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(repository: DayRepositoryProtocol,
         meal: Meal,
         date: Date = Date()) {
        self.repository = repository
        self.meal = BehaviorRelay<Meal>(value: meal)
        input = Input()
        output = Output(contentDidAdd: contentDidAdd.asObservable(),
                        contentDidDelete: contentDidDelete.asObservable(),
                        contentDidUpdate: contentDidUpdate.asObservable(),
                        day: day.asObservable(),
                        meal: self.meal.asObservable())
    }

    var addMeal: Binder<Meal> {
        Binder(self) { me, meal in
            me.repository.add(meal: meal, to: me.day.value)
        }
    }

    var addContent: Binder<(Meal, Content)> {
        Binder(self) { me, tuple in
            me.repository.add(content: tuple.1, to: tuple.0)
            me.contentDidAdd.accept(())
        }
    }

    var updateContent: Binder<(Content, Content)> {
        Binder<(Content, Content)>(self) { me, tuple in
            guard
                !tuple.0.isInvalidated,
                !tuple.1.isInvalidated
            else { return }
            me.repository.update(name: tuple.0.name, of: tuple.1)
            me.repository.update(calorie: tuple.0.calorie, of: tuple.1)
            me.repository.update(multiple: tuple.0.multiple, of: tuple.1)
            me.contentDidUpdate.accept(tuple.1)
        }
    }

    var saveName: Binder<(Content, String)> {
        Binder(self) { me, tuple in
            let content = tuple.0
            guard !content.isInvalidated else { return }
            me.repository.update(name: tuple.1, of: content)
            me.contentDidUpdate.accept(content)
        }
    }

    var saveCalorie: Binder<(Content, Double)> {
        Binder(self) { me, tuple in
            let content = tuple.0
            guard !content.isInvalidated else { return }
            me.repository.update(calorie: tuple.1, of: content)
            me.contentDidUpdate.accept(content)
        }
    }

    var saveMultiple: Binder<(Content, Double)> {
        Binder(self) { me, tuple in
            let content = tuple.0
            guard !content.isInvalidated else { return }
            me.repository.update(multiple: tuple.1, of: content)
            me.contentDidUpdate.accept(content)
        }
    }

    var deleteContent: Binder<(Meal, Content)> {
        Binder(self) { me, tuple in
            let content = tuple.1
            guard !content.isInvalidated else { return }
            me.repository.delete(content: tuple.1, of: tuple.0)
            me.contentDidDelete.accept(())
        }
    }
}

extension InputMealModel {
    struct Input: InputMealModelInput {}

    struct Output: InputMealModelOutput {
        let contentDidAdd: Observable<Void>
        let contentDidDelete: Observable<Void>
        let contentDidUpdate: Observable<Content>
        let day: Observable<Day>
        let meal: Observable<Meal>
    }
}
