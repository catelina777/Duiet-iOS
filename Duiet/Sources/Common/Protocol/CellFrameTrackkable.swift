//
//  CellFrameTrackkable.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/05/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxRelay
import RxSwift
import UIKit

protocol CellFrameTrackkable {
    func configure(textField: RoundedTextField, input: KeyboardTrackViewModelInput, output: KeyboardTrackViewModelOutput)
}

extension CellFrameTrackkable where Self: BaseTableViewCell {
    func configure(textField: RoundedTextField, input: KeyboardTrackViewModelInput, output: KeyboardTrackViewModelOutput) {
        guard
            let appDelegate = UIApplication.shared.delegate,
            let optionalWindow = appDelegate.window,
            let window = optionalWindow
        else { return }

        textField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { _ in
                let frame = textField.convert(textField.frame, to: window)
                input.inputFieldFrame.on(.next(frame))
            })
            .disposed(by: disposeBag)

        // Detect the keyboard layout change being edited and get the current value of the input form layout.
        // If you do not do this, the old input form layout is referenced and scrolling does not work properly.
        output.keyboardFrame
            .filter { _ in textField.isEditing }
            .map { _ in }
            .subscribe(onNext: {
                let frame = textField.convert(textField.frame, to: window)
                input.inputFieldFrame.on(.next(frame))
            })
            .disposed(by: disposeBag)
    }
}
