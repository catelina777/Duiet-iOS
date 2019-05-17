//
//  CellFrameTrackkable.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/05/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

protocol CellFrameTrackkable {
    func configure(with viewModel: KeyboardTrackViewModel)
    func configure(for textField: MyTextField, viewModel: KeyboardTrackViewModel, window: UIWindow)
}

extension CellFrameTrackkable where Self: RxTableViewCell {

    func configure(for textField: MyTextField, viewModel: KeyboardTrackViewModel, window: UIWindow) {
        textField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { _ in
                let frame = textField.convert(textField.frame, to: window)
                viewModel.input.inputFieldFrame.on(.next(frame))
            })
            .disposed(by: disposeBag)

        // Detect the keyboard layout change being edited and get the current value of the input form layout.
        // If you do not do this, the old input form layout is referenced and scrolling does not work properly.
        viewModel.output.keyboardFrame
            .filter { _ in textField.isEditing }
            .map { _ in }
            .subscribe(onNext: {
                let frame = textField.convert(textField.frame, to: window)
                viewModel.input.inputFieldFrame.on(.next(frame))
            })
            .disposed(by: disposeBag)
    }
}
