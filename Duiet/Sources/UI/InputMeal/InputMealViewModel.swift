//
//  InputMealViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/05/03.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class InputMealViewModel {

    let mealImage: UIImage?

    let input: Input
    let output: Output

    private let _mealLabelViews = BehaviorRelay<[MealLabelView]>(value: [])
    private let disposeBag = DisposeBag()

    init(mealImage: UIImage?,
         meal: Meal) {

        self.mealImage = mealImage

        let _addMealLabel = PublishRelay<MealLabelView?>()
        input = Input(addMealLabel: _addMealLabel.asObserver())

        output = Output(mealLabelViews: _mealLabelViews.asObservable())

        _addMealLabel
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] mealLabelView in
                guard let self = self else { return }
                var mealLabelViews = self._mealLabelViews.value
                mealLabelViews.append(mealLabelView)
                self._mealLabelViews.accept(mealLabelViews)
            })
            .disposed(by: disposeBag)
    }
}

extension InputMealViewModel {

    struct Input {
        let addMealLabel: AnyObserver<MealLabelView?>
    }

    struct Output {
        let mealLabelViews: Observable<[MealLabelView]>
    }
}
