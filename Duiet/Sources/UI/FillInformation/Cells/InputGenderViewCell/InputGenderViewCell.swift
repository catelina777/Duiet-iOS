//
//  InputGenderViewCell.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/18.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxCocoa

final class InputGenderViewCell: RxTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    let borderColor = #colorLiteral(red: 0.2588235294, green: 0.6470588235, blue: 0.9607843137, alpha: 1).cgColor

    @IBOutlet weak var maleButton: UIButton! {
        didSet {
            maleButton.configureGender()
        }
    }

    @IBOutlet weak var femaleButton: UIButton! {
        didSet {
            femaleButton.configureGender()
        }
    }

    func configure(with viewModel: FillInformationViewModel, cellType: CellType) {
        titleLabel.text = cellType.rawValue

        maleButton.rx.tap
            .subscribe(onNext: { _ in
                viewModel.input.gender.on(.next(true))
            })
            .disposed(by: disposeBag)

        femaleButton.rx.tap
            .subscribe(onNext: { _ in
                viewModel.input.gender.on(.next(false))
            })
            .disposed(by: disposeBag)

        viewModel.output.gender
            .bind(to: switchSelectedButton)
            .disposed(by: disposeBag)
    }

    var switchSelectedButton: Binder<Bool?> {
        return Binder(self) { me, bool in
            guard let bool = bool else { return }
            if bool {
                me.maleButton.layer.borderColor = me.borderColor
                me.femaleButton.layer.borderColor = UIColor.clear.cgColor
            } else {
                me.femaleButton.layer.borderColor = me.borderColor
                me.maleButton.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
}
