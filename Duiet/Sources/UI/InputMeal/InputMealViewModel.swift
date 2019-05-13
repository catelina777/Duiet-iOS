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

    init(mealImage: UIImage?) {

        self.mealImage = mealImage

        let _inputFieldTap = PublishRelay<CGRect>()
        let _addMealLabel = PublishRelay<MealLabelView?>()

        input = Input(inputFieldTap: _inputFieldTap.asObserver(),
                      addMealLabel: _addMealLabel.asObserver())

        let _keyboardWillShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue }
            .compactMap { $0 }
            .share()

        let _keyboardWillHide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { _ in }
            .share()

        output = Output(keyboardWillShow: _keyboardWillShow,
                        keyboardWillHide: _keyboardWillHide,
                        inputFieldTap: _inputFieldTap.asObservable(),
                        mealLabelViews: _mealLabelViews.asObservable())

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
        let inputFieldTap: AnyObserver<CGRect>
        let addMealLabel: AnyObserver<MealLabelView?>
    }

    struct Output {
        let keyboardWillShow: Observable<CGRect>
        let keyboardWillHide: Observable<Void>
        let inputFieldTap: Observable<CGRect>
        let mealLabelViews: Observable<[MealLabelView]>
    }
}
