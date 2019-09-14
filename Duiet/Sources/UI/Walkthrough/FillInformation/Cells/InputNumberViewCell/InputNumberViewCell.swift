//
//  InputNumberViewCell.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxSwift
import UIKit

final class InputNumberViewCell: InputPickerViewCell, CellFrameTrackkable {
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
            let list = [Double].init(repeating: 0, count: 215)
                .enumerated()
                .map { Double($0.offset) }
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
            let list = [Double].init(repeating: 0, count: 150)
                .enumerated()
                .map { Double($0.offset) * 0.5 + 20 }
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

        if type == .age {
            let list =  [Int].init(repeating: 0, count: 120)
                .enumerated()
                .map { $0.offset }
            let unit = " years old"
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
