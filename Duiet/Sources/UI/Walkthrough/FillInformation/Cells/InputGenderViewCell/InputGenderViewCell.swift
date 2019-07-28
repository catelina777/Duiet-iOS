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
            let borderColor = R.color.main()?.cgColor
            if bool {
                me.maleButton.layer.borderColor = borderColor
                me.femaleButton.layer.borderColor = UIColor.clear.cgColor
            } else {
                me.femaleButton.layer.borderColor = borderColor
                me.maleButton.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
}
