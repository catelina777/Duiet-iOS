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
                button.backgroundColor = R.color.componentMain()!
                button.isEnabled = bool
            } else {
                button.backgroundColor = .systemGray3
                button.isEnabled = bool
            }
        }
    }

    func configure(with viewModel: FillInformationViewModelProtocol) {
        viewModel.output.isValidateComplete
            .bind(to: isComplete)
            .disposed(by: disposeBag)

        completeButton.rx.tap
            .bind(to: viewModel.input.didTapCompleteButton)
            .disposed(by: disposeBag)
    }
}
