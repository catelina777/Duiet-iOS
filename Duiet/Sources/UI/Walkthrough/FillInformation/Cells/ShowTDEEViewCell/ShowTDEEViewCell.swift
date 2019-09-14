//
//  ShowTDEEViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/04/27.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class ShowTDEEViewCell: BaseTableViewCell {
    @IBOutlet weak var BMRValueLabel: UILabel!
    @IBOutlet weak var TDEEValueLabel: UILabel!

    func configure(with viewModel: FillInformationViewModelProtocol) {
        viewModel.output.BMR
            .bind(to: BMRValueLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.TDEE
            .bind(to: TDEEValueLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
