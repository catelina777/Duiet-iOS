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

        // MARK: Apply theme
        let theme = AppAppearance.shared.themeService.attrs
        titleLabel.textColor = theme.textMainColor
    }
}
