//
//  InputNumberViewCell.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift

final class InputNumberViewCell: InputPickerViewCell {

    func configure(with viewModel: FillInformationViewModel, type: CellType) {
        super.configure(with: type)
        if type == .height {
            let list = viewModel.heightList
            let unit = " cm"
            let defaultRow = 140

            Observable.just(list.map { String($0) + unit })
                .bind(to: pickerView.rx.itemTitles) { $1 }
                .disposed(by: disposeBag)

            pickerView.selectRow(defaultRow, inComponent: 0, animated: true)

            pickerView.rx.itemSelected
                .map { list[$0.row] }
                .bind(to: viewModel.input.height)
                .disposed(by: disposeBag)

            pickerView.rx.itemSelected
                .map { String(list[$0.row]) + unit }
                .bind(to: textField.rx.text)
                .disposed(by: disposeBag)
        }

        if type == .weight {
            let list = viewModel.weightList
            let unit = " kg"
            let defaultRow = 80

            Observable.just(list.map { String($0) + unit })
                .bind(to: pickerView.rx.itemTitles) { $1 }
                .disposed(by: disposeBag)

            pickerView.selectRow(defaultRow, inComponent: 0, animated: true)

            pickerView.rx.itemSelected
                .map { list[$0.row] }
                .bind(to: viewModel.input.weight)
                .disposed(by: disposeBag)

            pickerView.rx.itemSelected
                .map { String(list[$0.row]) + unit }
                .bind(to: textField.rx.text)
                .disposed(by: disposeBag)
        }
    }
}
