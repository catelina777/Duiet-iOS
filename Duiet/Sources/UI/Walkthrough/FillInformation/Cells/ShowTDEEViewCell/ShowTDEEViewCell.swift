//
//  ShowTDEEViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/04/27.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class ShowTDEEViewCell: BaseTableViewCell {
    @IBOutlet weak var BMRLabel: UILabel!
    @IBOutlet weak var TDEELabel: UILabel!
    @IBOutlet weak var BMRValueLabel: UILabel!
    @IBOutlet weak var TDEEValueLabel: UILabel!
    @IBOutlet weak var equalLabel1: UILabel!
    @IBOutlet weak var equalLabel2: UILabel!

    func configure(with viewModel: FillInformationViewModel) {
        viewModel.output.BMR
            .bind(to: BMRValueLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.TDEE
            .bind(to: TDEEValueLabel.rx.text)
            .disposed(by: disposeBag)

        // MARK: Apply theme
        let theme = AppAppearance.shared.themeService.attrs
        [BMRValueLabel,
         TDEEValueLabel,
         BMRLabel,
         TDEELabel,
         equalLabel1,
         equalLabel2].forEach { $0?.textColor = theme.textMainColor }
    }
}
