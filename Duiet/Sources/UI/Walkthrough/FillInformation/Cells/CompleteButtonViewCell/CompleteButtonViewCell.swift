//
//  CompleteButtonViewCell.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/19.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxCocoa
import UIKit

final class CompleteButtonViewCell: BaseTableViewCell {
    @IBOutlet weak var completeButton: UIButton! {
        didSet {
            completeButton.layer.cornerRadius = 10
        }
    }

    var isComplete: Binder<Bool> {
        return Binder(completeButton) { button, bool in
            if bool {
                button.backgroundColor = AppAppearance.shared.themeService.attrs.buttonMainColor
                button.isEnabled = bool
            } else {
                button.backgroundColor = AppAppearance.shared.themeService.attrs.buttonDisableColor
                button.isEnabled = bool
            }
        }
    }

    func configure(with viewModel: FillInformationViewModel) {
        viewModel.output.isValidateComplete
            .bind(to: isComplete)
            .disposed(by: disposeBag)

        completeButton.rx.tap
            .bind(to: viewModel.input.didTapComplete)
            .disposed(by: disposeBag)
    }
}
