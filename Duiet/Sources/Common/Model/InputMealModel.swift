//
//  InputMealModel.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/07/11.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxCocoa
import RxRelay
import RxSwift

protocol InputMealModelInput {}

protocol InputMealModelOutput {
    var contentDidAdd: Observable<Void> { get }
    var contentDidDelete: Observable<Void> { get }
    var contentDidUpdate: Observable<Food> { get }
    var meal: Observable<MealEntity> { get }
    var dayEntity: Observable<DayEntity> { get }
}

protocol InputMealModelState {
    var mealEntityValue: MealEntity { get }
    var addFood: Binder<(Food, MealEntity)> { get }
    var updateContent: Binder<(Food, Food)> { get }
    var saveName: Binder<(Food, String)> { get }
    var saveCalorie: Binder<(Food, Double)> { get }
    var saveMultiple: Binder<(Food, Double)> { get }
    var deleteFood: Binder<Food> { get }
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
    private let contentDidUpdate = PublishRelay<Food>()
    private let contentDidDelete = PublishRelay<Void>()
    private let meal: BehaviorRelay<MealEntity>
    private let dayEntity: BehaviorRelay<DayEntity>

    // MARK: State
    var mealEntityValue: MealEntity {
        meal.value
    }

    var dayEntityValue: DayEntity {
        dayEntity.value
    }

    private let foodService: FoodServiceProtocol
    private let mealService: MealServiceProtocol
    private let disposeBag = DisposeBag()

    init(mealEntity: MealEntity,
         dayEntity: DayEntity,
         foodService: FoodServiceProtocol = FoodService.shared,
         mealService: MealServiceProtocol = MealService.shared) {
        self.foodService = foodService
        self.mealService = mealService
        meal = BehaviorRelay<MealEntity>(value: mealEntity)
        self.dayEntity = BehaviorRelay<DayEntity>(value: dayEntity)
        input = Input()
        output = Output(contentDidAdd: contentDidAdd.asObservable(),
                        contentDidDelete: contentDidDelete.asObservable(),
                        contentDidUpdate: contentDidUpdate.asObservable(),
                        meal: self.meal.asObservable(),
                        dayEntity: self.dayEntity.asObservable())
    }

    var addMeal: Binder<Meal> {
        Binder<Meal>(self) { me, meal in
            me.mealService.add(meal, to: me.dayEntityValue)
        }
    }

    var addFood: Binder<(Food, MealEntity)> {
        Binder<(Food, MealEntity)>(self) { me, tuple in
            me.foodService.add(tuple.0, mealEntity: tuple.1)
            me.contentDidAdd.accept(())
        }
    }

    var updateContent: Binder<(Food, Food)> {
        Binder<(Food, Food)>(self) { me, tuple in
            let updatedFood = me.foodService.update(tuple.0,
                                                    name: tuple.1.name,
                                                    calorie: tuple.1.calorie,
                                                    multiple: tuple.1.multiple,
                                                    updatedAt: Date())
            me.contentDidUpdate.accept(updatedFood)
        }
    }

    var saveName: Binder<(Food, String)> {
        Binder<(Food, String)>(self) { me, tuple in
            let updatedFood = me.foodService.update(tuple.0,
                                                    name: tuple.1,
                                                    calorie: tuple.0.calorie,
                                                    multiple: tuple.0.multiple,
                                                    updatedAt: Date())
            me.contentDidUpdate.accept(updatedFood)
        }
    }

    var saveCalorie: Binder<(Food, Double)> {
        Binder<(Food, Double)>(self) { me, tuple in
            let updatedFood = me.foodService.update(tuple.0,
                                                    name: tuple.0.name,
                                                    calorie: tuple.1,
                                                    multiple: tuple.0.multiple,
                                                    updatedAt: Date())
            me.contentDidUpdate.accept(updatedFood)
        }
    }

    var saveMultiple: Binder<(Food, Double)> {
        Binder<(Food, Double)>(self) { me, tuple in
            let updatedFood = me.foodService.update(tuple.0,
                                                    name: tuple.0.name,
                                                    calorie: tuple.0.calorie,
                                                    multiple: tuple.1,
                                                    updatedAt: Date())
            me.contentDidUpdate.accept(updatedFood)
        }
    }

    var deleteFood: Binder<Food> {
        Binder<Food>(self) { me, food in
            me.foodService.delete(food)
            me.contentDidDelete.accept(())
        }
    }
}

extension InputMealModel {
    struct Input: InputMealModelInput {}

    struct Output: InputMealModelOutput {
        let contentDidAdd: Observable<Void>
        let contentDidDelete: Observable<Void>
        let contentDidUpdate: Observable<Food>
        let meal: Observable<MealEntity>
        let dayEntity: Observable<DayEntity>
    }
}
