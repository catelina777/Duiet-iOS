//
//  InputNumberViewCell.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxSwift
import UIKit

final class InputNumberViewCell: InputPickerViewCell, CellFrameTrackkable, UnitLocalizable {
    func configure(with viewModel: KeyboardTrackViewModel) {
        guard
            let appDelegate = UIApplication.shared.delegate,
            let optionalWindow = appDelegate.window,
            let window = optionalWindow
        else { return }

        configure(for: textField,
                  viewModel: viewModel,
                  window: window)
    }

    func configure(with viewModel: FillInformationViewModelProtocol, type: CellType) {
        super.configure(with: type)
        if type == .height {
            let list = Array(stride(from: 50.0, to: 230.0, by: 1.0))
            let unit = " " + unitSymbol(UnitLength.centimeters, style: .medium)
            let defaultRow = 160 - 50

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
            let list = Array(stride(from: 20, to: 150, by: 0.5))
            let unit = " " + unitSymbol(UnitMass.kilograms, style: .medium)
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

        if type == .age {
            let list = Array(stride(from: 0, to: 121, by: 1))
            let unit = " " + R.string.localizable.yearsOld()
            let defaultRow = 30

            Observable.just(list.map { String($0) })
                .bind(to: pickerView.rx.itemTitles) { $1 }
                .disposed(by: disposeBag)

            pickerView.selectRow(defaultRow, inComponent: 0, animated: true)

            pickerView.rx.itemSelected
                .map { list[$0.row] }
                .bind(to: viewModel.input.age)
                .disposed(by: disposeBag)

            pickerView.rx.itemSelected
                .map { String(list[$0.row]) + unit }
                .bind(to: textField.rx.text)
                .disposed(by: disposeBag)
        }
    }
}
