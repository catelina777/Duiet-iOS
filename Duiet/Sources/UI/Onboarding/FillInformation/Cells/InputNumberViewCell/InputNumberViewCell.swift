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

    func configure(with viewModel: FillInformationViewModelProtocol, type: FillInformationCellType) {
        super.configure(with: type)

        switch type {
        case .height:
            configureHeightCell(with: viewModel, type: type)

        case .weight:
            configureHeightCell(with: viewModel, type: type)

        case .age:
            configureAgeCell(with: viewModel, type: type)

        default:
            break
        }
    }

    private func configureHeightCell(with viewModel: FillInformationViewModelProtocol, type: FillInformationCellType) {
        let heightCollectionInCentimeters = Array(stride(from: 50.0, to: 230.0, by: 1.0))
        let defaultRow = 160 - 50

        let heightCollectionWithSymbol = heightCollectionInCentimeters
            .map {
                UnitBabel.shared.convertWithSymbol(value: $0,
                                                   from: .centimeters,
                                                   to: viewModel.state.unitCollectionValue.heightUnit)
            }

        Observable.just(heightCollectionWithSymbol)
            .bind(to: pickerView.rx.itemTitles) { $1 }
            .disposed(by: disposeBag)

        pickerView.selectRow(defaultRow, inComponent: 0, animated: true)

        pickerView.rx.itemSelected
            .map { heightCollectionInCentimeters[$0.row] }
            .bind(to: viewModel.input.height)
            .disposed(by: disposeBag)

        pickerView.rx.itemSelected
            .map {
                UnitBabel.shared.convertWithSymbol(value: heightCollectionInCentimeters[$0.row],
                                                   from: .centimeters,
                                                   to: viewModel.state.unitCollectionValue.heightUnit)
            }
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
    }

    private func configureWeightCell(with viewModel: FillInformationViewModelProtocol, type: FillInformationCellType) {
        let weightCollectionInKilograms = Array(stride(from: 20, to: 150, by: 0.5))
        let defaultRow = 80 - 20

        let weightCollectionWithSymbol = weightCollectionInKilograms
            .map {
                UnitBabel.shared.convertRoundedWithSymbol(value: $0,
                                                          from: .kilograms,
                                                          to: viewModel.state.unitCollectionValue.weightUnit,
                                                          significantDigits: 1)
            }

        Observable.just(weightCollectionWithSymbol)
            .bind(to: pickerView.rx.itemTitles) { $1 }
            .disposed(by: disposeBag)

        pickerView.selectRow(defaultRow, inComponent: 0, animated: true)

        pickerView.rx.itemSelected
            .map { weightCollectionInKilograms[$0.row] }
            .bind(to: viewModel.input.weight)
            .disposed(by: disposeBag)

        pickerView.rx.itemSelected
            .map {
                UnitBabel.shared.convertRoundedWithSymbol(value: weightCollectionInKilograms[$0.row],
                                                          from: .kilograms,
                                                          to: viewModel.state.unitCollectionValue.weightUnit,
                                                          significantDigits: 1)
            }
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
    }

    private func configureAgeCell(with viewModel: FillInformationViewModelProtocol, type: FillInformationCellType) {
        let ageCollection = Array(stride(from: 0, to: 121, by: 1))
        let unit = " " + R.string.localizable.yearsOld()
        let defaultRow = 30

        Observable.just(ageCollection.map { String($0) + unit })
            .bind(to: pickerView.rx.itemTitles) { $1 }
            .disposed(by: disposeBag)

        pickerView.selectRow(defaultRow, inComponent: 0, animated: true)

        pickerView.rx.itemSelected
            .map { ageCollection[$0.row] }
            .bind(to: viewModel.input.age)
            .disposed(by: disposeBag)

        pickerView.rx.itemSelected
            .map { String(ageCollection[$0.row]) + unit }
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
    }
}
