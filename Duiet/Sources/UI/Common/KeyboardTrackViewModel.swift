//
//  KeyboardTrackViewModel.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/05/16.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxRelay
import RxSwift
import UIKit

protocol KeyboardTrackViewModelInput {
    var inputFieldFrame: AnyObserver<CGRect> { get }
}

protocol KeyboardTrackViewModelOutput {
    var keyboardFrame: Observable<CGRect> { get }
    var inputFieldFrame: Observable<CGRect> { get }
    var difference: Observable<CGFloat> { get }
}

protocol KeyboardTrackViewModelState {}

protocol KeyboardTrackViewModelProtocol {
    var input: KeyboardTrackViewModelInput { get }
    var output: KeyboardTrackViewModelOutput { get }
    var state: KeyboardTrackViewModelState { get }
}

final class KeyboardTrackViewModel: KeyboardTrackViewModelProtocol, KeyboardTrackViewModelState {
    let input: KeyboardTrackViewModelInput
    let output: KeyboardTrackViewModelOutput
    var state: KeyboardTrackViewModelState { self }

    init() {
        let inputFieldFrame = PublishRelay<CGRect>()
        input = Input(inputFieldFrame: inputFieldFrame.asObserver())

        let keyboardFrame = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue }
            .compactMap { $0 }
            .share()

        let difference = Observable.combineLatest(inputFieldFrame, keyboardFrame)
            .map { $0.0.maxY - $0.1.minY }
            .filter { $0 > 0 }
            .share()

        output = Output(keyboardFrame: keyboardFrame,
                        inputFieldFrame: inputFieldFrame.asObservable(),
                        difference: difference)
    }
}

extension KeyboardTrackViewModel {
    struct Input: KeyboardTrackViewModelInput {
        let inputFieldFrame: AnyObserver<CGRect>
    }

    struct Output: KeyboardTrackViewModelOutput {
        let keyboardFrame: Observable<CGRect>
        let inputFieldFrame: Observable<CGRect>
        let difference: Observable<CGFloat>
    }
}
