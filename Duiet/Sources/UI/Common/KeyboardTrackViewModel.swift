//
//  KeyboardTrackViewModel.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/05/16.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

final class KeyboardTrackViewModel {

    let input: Input
    let output: Output

    init() {
        let _inputFieldFrame = PublishRelay<CGRect>()
        input = Input(inputFieldFrame: _inputFieldFrame.asObserver())

        let _keyboardFrame = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue }
            .compactMap { $0 }
            .share()

        let _difference = Observable.combineLatest(_inputFieldFrame, _keyboardFrame)
            .filter { ($0.0.maxY - $0.1.minY) > 0 }
            .map { $0.0.maxY - $0.1.minY }
            .distinctUntilChanged()
            .share()

        output = Output(keyboardFrame: _keyboardFrame,
                        inputFieldFrame: _inputFieldFrame.asObservable(),
                        difference: _difference)
    }

}

extension KeyboardTrackViewModel {

    struct Input {
        let inputFieldFrame: AnyObserver<CGRect>
    }

    struct Output {
        let keyboardFrame: Observable<CGRect>
        let inputFieldFrame: Observable<CGRect>
        let difference: Observable<CGFloat>
    }
}
