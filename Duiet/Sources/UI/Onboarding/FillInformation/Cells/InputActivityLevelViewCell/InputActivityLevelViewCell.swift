//
//  InputActivityLevelViewCell.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/18.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxSwift
import UIKit

final class InputActivityLevelViewCell: InputPickerViewCell, CellFrameTrackkable {
    func configure(input: KeyboardTrackViewModelInput, output: KeyboardTrackViewModelOutput) {
        configure(textField: textField, input: input, output: output)
    }

    func configure(input: FillInformationViewModelInput) {
        Observable.just(ActivityLevelType.allCases.map { $0.description })
            .bind(to: pickerView.rx.itemTitles) { $1 }
            .disposed(by: disposeBag)

        pickerView.rx.itemSelected
            .map { ActivityLevelType.get($0.row) }
            .bind(to: input.activityLevel)
            .disposed(by: disposeBag)

        pickerView.rx.itemSelected
            .map { ActivityLevelType.get($0.row).text }
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
    }
}
