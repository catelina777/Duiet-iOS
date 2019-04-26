//
//  InputActivityLevelViewCell.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/18.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift

final class InputActivityLevelViewCell: InputPickerViewCell {

    func configure(with viewModel: FillInformationViewModel) {
        Observable.just(viewModel.activityTypes.map { $0.description })
            .bind(to: pickerView.rx.itemTitles) { $1 }
            .disposed(by: disposeBag)

        pickerView.rx.itemSelected
            .map { ActivityLevel.getType(with: $0.row) }
            .bind(to: viewModel.input.activityLevel)
            .disposed(by: disposeBag)

        pickerView.rx.itemSelected
            .map { ActivityLevel.getType(with: $0.row).text }
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
    }
}
