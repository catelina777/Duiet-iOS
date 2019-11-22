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
    var contentDidUpdate: AnyObserver<FoodEntity> { get }
    var contentDidDelete: AnyObserver<Void> { get }
}

protocol MealLabelViewModelOutput {
    var contentDidUpdate: Observable<FoodEntity> { get }
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

        let contentDidUpdate = PublishRelay<FoodEntity>()
        let contentDidDelete = PublishRelay<Void>()
        input = Input(contentDidUpdate: contentDidUpdate.asObserver(),
                      contentDidDelete: contentDidDelete.asObserver())

        let hideView = contentDidDelete
        output = Output(contentDidUpdate: contentDidUpdate.asObservable(),
                        hideView: hideView.asObservable())

        contentDidUpdate
            .subscribe(onNext: { [weak self] foodEntity in
                guard let me = self else { return }
                me.foodEntity.accept(foodEntity)
            })
            .disposed(by: disposeBag)
    }
}

extension MealLabelViewModel {
    struct Input: MealLabelViewModelInput {
        let contentDidUpdate: AnyObserver<FoodEntity>
        let contentDidDelete: AnyObserver<Void>
    }

    struct Output: MealLabelViewModelOutput {
        let contentDidUpdate: Observable<FoodEntity>
        let hideView: Observable<Void>
    }
}
