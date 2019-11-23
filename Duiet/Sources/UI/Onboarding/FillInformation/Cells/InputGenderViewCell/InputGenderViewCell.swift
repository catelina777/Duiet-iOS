//
//  InputGenderViewCell.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/18.
//  Copyright © 2019 Duiet. All rights reserved.
//

import RxCocoa
import UIKit

final class InputGenderViewCell: BaseTableViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var maleButton: UIButton! {
        didSet {
            maleButton.makeEdges(cornerRadius: 10, borderWidth: 4)
            maleButton.setTitle(R.string.localizable.male(), for: .normal)
        }
    }

    @IBOutlet weak var femaleButton: UIButton! {
        didSet {
            femaleButton.makeEdges(cornerRadius: 10, borderWidth: 4)
            femaleButton.setTitle(R.string.localizable.female(), for: .normal)
        }
    }

    func configure(with viewModel: FillInformationViewModelProtocol, cellType: FillInformationCellType) {
        titleLabel.text = cellType.title

        maleButton.rx.tap
            .subscribe(onNext: { _ in
                viewModel.input.biologicalSex.onNext(.male)
            })
            .disposed(by: disposeBag)

        femaleButton.rx.tap
            .subscribe(onNext: { _ in
                viewModel.input.biologicalSex.onNext(.female)
            })
            .disposed(by: disposeBag)

        viewModel.output.biologicalSex
            .bind(to: switchSelectedButton)
            .disposed(by: disposeBag)
    }

    var switchSelectedButton: Binder<BiologicalSexType?> {
        Binder<BiologicalSexType?>(self) { me, biologicalSex in
            guard let biologicalSex = biologicalSex else { return }
            let borderColor = R.color.componentMain()!.cgColor
            switch biologicalSex {
            case .male:
                me.maleButton.layer.borderColor = borderColor
                me.femaleButton.layer.borderColor = UIColor.clear.cgColor

            case .female:
                me.femaleButton.layer.borderColor = borderColor
                me.maleButton.layer.borderColor = UIColor.clear.cgColor

            case .other:
                me.maleButton.layer.borderColor = UIColor.clear.cgColor
                me.femaleButton.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
}
