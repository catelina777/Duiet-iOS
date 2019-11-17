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
    var contentDidUpdate: AnyObserver<Food> { get }
    var contentDidDelete: AnyObserver<Void> { get }
}

protocol MealLabelViewModelOutput {
    var contentDidUpdate: Observable<Food> { get }
    var hideView: Observable<Void> { get }
}

protocol MealLabelViewModelState {
    var foodValue: Food { get }
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

    var foodValue: Food {
        food.value
    }

    private let food: BehaviorRelay<Food>
    private let disposeBag = DisposeBag()

    init(food: Food) {
        self.food = BehaviorRelay<Food>(value: food)

        let contentDidUpdate = PublishRelay<Food>()
        let contentDidDelete = PublishRelay<Void>()
        input = Input(contentDidUpdate: contentDidUpdate.asObserver(),
                      contentDidDelete: contentDidDelete.asObserver())

        let hideView = contentDidDelete
        output = Output(contentDidUpdate: contentDidUpdate.asObservable(),
                        hideView: hideView.asObservable())

        contentDidUpdate
            .subscribe(onNext: { [weak self] food in
                guard let me = self else { return }
                me.food.accept(food)
            })
            .disposed(by: disposeBag)
    }
}

extension MealLabelViewModel {
    struct Input: MealLabelViewModelInput {
        let contentDidUpdate: AnyObserver<Food>
        let contentDidDelete: AnyObserver<Void>
    }

    struct Output: MealLabelViewModelOutput {
        let contentDidUpdate: Observable<Food>
        let hideView: Observable<Void>
    }
}
