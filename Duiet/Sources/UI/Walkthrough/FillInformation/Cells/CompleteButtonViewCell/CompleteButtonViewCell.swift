//
//  CompleteButtonViewCell.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/19.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxCocoa

final class CompleteButtonViewCell: RxTableViewCell {

    @IBOutlet weak var completeButton: UIButton! {
        didSet {
            completeButton.layer.cornerRadius = 10
        }
    }

    var isComplete: Binder<Bool> {
        return Binder(completeButton) { button, bool in
            if bool {
                button.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                button.isEnabled = bool
            } else {
                button.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                button.isEnabled = bool
            }
        }
    }

    func configure(with viewModel: FillInformationViewModel) {
        viewModel.output.isValidateComplete
            .bind(to: isComplete)
            .disposed(by: disposeBag)

        completeButton.rx.tap
            .bind(to: viewModel.input.completeButtonTap)
            .disposed(by: disposeBag)
    }
}
