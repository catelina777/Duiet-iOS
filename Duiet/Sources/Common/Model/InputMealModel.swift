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
    var foodDidAdd: Observable<Void> { get }
    var foodDidDelete: Observable<Void> { get }
    var foodDidUpdate: Observable<FoodEntity> { get }
    var meal: Observable<MealEntity> { get }
    var dayEntity: Observable<DayEntity> { get }
}

protocol InputMealModelState {
    var mealEntityValue: MealEntity { get }
    var update: Binder<FoodEntity> { get }
    var add: Binder<FoodEntity> { get }
    var delete: Binder<FoodEntity> { get }
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

    private let foodDidAdd = PublishRelay<Void>()
    private let foodDidUpdate = PublishRelay<FoodEntity>()
    private let foodDidDelete = PublishRelay<Void>()
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
    private let disposeBag = DisposeBag()

    init(mealEntity: MealEntity,
         dayEntity: DayEntity,
         foodService: FoodServiceProtocol = FoodService.shared) {
        self.foodService = foodService
        meal = BehaviorRelay<MealEntity>(value: mealEntity)
        self.dayEntity = BehaviorRelay<DayEntity>(value: dayEntity)
        input = Input()
        output = Output(foodDidAdd: foodDidAdd.asObservable(),
                        foodDidDelete: foodDidDelete.asObservable(),
                        foodDidUpdate: foodDidUpdate.asObservable(),
                        meal: self.meal.asObservable(),
                        dayEntity: self.dayEntity.asObservable())
    }

    var add: Binder<FoodEntity> {
        Binder<FoodEntity>(self) { me, foodEntity in
            me.foodService.update(foodEntity)
            me.foodDidAdd.accept(())
        }
    }

    var update: Binder<FoodEntity> {
        Binder<FoodEntity>(self) { me, foodEntity in
            me.foodService.update(foodEntity)
            me.foodDidUpdate.accept(foodEntity)
        }
    }

    var delete: Binder<FoodEntity> {
        Binder<FoodEntity>(self) { me, foodEntity in
            me.foodService.delete(foodEntity)
            me.foodDidDelete.accept(())
        }
    }
}

extension InputMealModel {
    struct Input: InputMealModelInput {}

    struct Output: InputMealModelOutput {
        let foodDidAdd: Observable<Void>
        let foodDidDelete: Observable<Void>
        let foodDidUpdate: Observable<FoodEntity>
        let meal: Observable<MealEntity>
        let dayEntity: Observable<DayEntity>
    }
}
