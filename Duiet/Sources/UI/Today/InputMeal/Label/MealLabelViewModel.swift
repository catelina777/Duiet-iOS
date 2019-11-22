//
//  MealLabelViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/10.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

protocol MealLabelViewModelInput {
    var foodDidUpdate: AnyObserver<FoodEntity> { get }
    var foodDidDelete: AnyObserver<Void> { get }
}

protocol MealLabelViewModelOutput {
    var foodDidUpdate: Observable<FoodEntity> { get }
    var hideView: Observable<Void> { get }
}

protocol MealLabelViewModelState {
    var foodEntityValue: FoodEntity { get }
}

protocol MealLabelViewModelProtocol {
    var input: MealLabelViewModelInput { get }
    var output: MealLabelViewModelOutput { get }
    var state: MealLabelViewModelState { get }
}

final class MealLabelViewModel: MealLabelViewModelProtocol, MealLabelViewModelState {
    let input: MealLabelViewModelInput
    let output: MealLabelViewModelOutput
    var state: MealLabelViewModelState { self }

    var foodEntityValue: FoodEntity {
        foodEntity.value
    }

    private let foodEntity: BehaviorRelay<FoodEntity>
    private let disposeBag = DisposeBag()

    init(foodEntity: FoodEntity) {
        self.foodEntity = BehaviorRelay<FoodEntity>(value: foodEntity)

        let foodDidUpdate = PublishRelay<FoodEntity>()
        let foodDidDelete = PublishRelay<Void>()
        input = Input(foodDidUpdate: foodDidUpdate.asObserver(),
                      foodDidDelete: foodDidDelete.asObserver())

        let hideView = foodDidDelete
        output = Output(foodDidUpdate: foodDidUpdate.asObservable(),
                        hideView: hideView.asObservable())

        foodDidUpdate
            .subscribe(onNext: { [weak self] foodEntity in
                guard let me = self else { return }
                me.foodEntity.accept(foodEntity)
            })
            .disposed(by: disposeBag)
    }
}

extension MealLabelViewModel {
    struct Input: MealLabelViewModelInput {
        let foodDidUpdate: AnyObserver<FoodEntity>
        let foodDidDelete: AnyObserver<Void>
    }

    struct Output: MealLabelViewModelOutput {
        let foodDidUpdate: Observable<FoodEntity>
        let hideView: Observable<Void>
    }
}
