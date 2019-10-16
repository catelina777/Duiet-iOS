//
//  ShowTDEEViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/04/27.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class ShowTDEEViewCell: BaseTableViewCell {
    @IBOutlet weak var BMRLabel: UILabel! {
        didSet { BMRLabel.text = R.string.localizable.bmr() }
    }

    @IBOutlet weak var TDEELabel: UILabel! {
        didSet { TDEELabel.text = R.string.localizable.tdee() }
    }

    @IBOutlet weak var BMRValueLabel: UILabel! {
        didSet { BMRValueLabel.text = R.string.localizable.calc() }
    }

    @IBOutlet weak var TDEEValueLabel: UILabel! {
        didSet { TDEEValueLabel.text = R.string.localizable.calc() }
    }

    func configure(with viewModel: FillInformationViewModelProtocol) {
        viewModel.output.BMR
            .bind(to: BMRValueLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.TDEE
            .bind(to: TDEEValueLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
