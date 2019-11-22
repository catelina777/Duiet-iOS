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
    var contentDidUpdate: Observable<FoodEntity> { get }
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

    private let contentDidAdd = PublishRelay<Void>()
    private let contentDidUpdate = PublishRelay<FoodEntity>()
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

    var add: Binder<FoodEntity> {
        Binder<FoodEntity>(self) { me, foodEntity in
            me.foodService.update(foodEntity)
            me.contentDidAdd.accept(())
        }
    }

    var update: Binder<FoodEntity> {
        Binder<FoodEntity>(self) { me, foodEntity in
            me.foodService.update(foodEntity)
            me.contentDidUpdate.accept(foodEntity)
        }
    }

    var delete: Binder<FoodEntity> {
        Binder<FoodEntity>(self) { me, foodEntity in
            me.foodService.delete(foodEntity)
            me.contentDidDelete.accept(())
        }
    }
}

extension InputMealModel {
    struct Input: InputMealModelInput {}

    struct Output: InputMealModelOutput {
        let contentDidAdd: Observable<Void>
        let contentDidDelete: Observable<Void>
        let contentDidUpdate: Observable<FoodEntity>
        let meal: Observable<MealEntity>
        let dayEntity: Observable<DayEntity>
    }
}
