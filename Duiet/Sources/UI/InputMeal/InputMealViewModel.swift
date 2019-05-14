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

        let _inputFieldFrame = PublishRelay<CGRect>()
        let _addMealLabel = PublishRelay<MealLabelView?>()

        input = Input(inputFieldFrame: _inputFieldFrame.asObserver(),
                      addMealLabel: _addMealLabel.asObserver())

        let _keyboardWillShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue }
            .compactMap { $0 }
            .share()

        let _keyboardWillHide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { _ in }
            .share()

        let _difference = Observable.combineLatest(_inputFieldFrame, _keyboardWillShow)
            .filter { ($0.0.maxY - $0.1.minY) > 0 }
            .map { $0.0.maxY - $0.1.minY }
            .distinctUntilChanged()
            .share()

        output = Output(keyboardWillShow: _keyboardWillShow,
                        keyboardWillHide: _keyboardWillHide,
                        mealLabelViews: _mealLabelViews.asObservable(),
                        inputFieldFrame: _inputFieldFrame.asObservable(),
                        difference: _difference)

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
        let inputFieldFrame: AnyObserver<CGRect>
        let addMealLabel: AnyObserver<MealLabelView?>
    }

    struct Output {
        let keyboardWillShow: Observable<CGRect>
        let keyboardWillHide: Observable<Void>
        let mealLabelViews: Observable<[MealLabelView]>
        let inputFieldFrame: Observable<CGRect>
        let difference: Observable<CGFloat>
    }
}
