//
//  ShowTDEEViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/04/27.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class ShowTDEEViewCell: RxTableViewCell {
    @IBOutlet weak var BMRLabel: UILabel!
    @IBOutlet weak var TDEELabel: UILabel!

    func configure(with viewModel: FillInformationViewModel) {
        viewModel.output.BMR
            .bind(to: BMRLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.TDEE
            .bind(to: TDEELabel.rx.text)
            .disposed(by: disposeBag)
    }
}
