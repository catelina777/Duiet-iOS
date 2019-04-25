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
    var isMale = BehaviorRelay<Bool?>(value: nil)
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

    override func awakeFromNib() {
        super.awakeFromNib()

        maleButton.rx.tap.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.isMale.accept(true)
        }.disposed(by: disposeBag)

        femaleButton.rx.tap.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.isMale.accept(false)
        }.disposed(by: disposeBag)

        isMale.asObservable().subscribe { [weak self] _ in
            guard let self = self else { return }
            self.switchSelectedButton(with: self.isMale.value)
        }.disposed(by: disposeBag)
    }

    func configure(with cellType: CellType) {
        titleLabel.text = cellType.rawValue
    }

    func switchSelectedButton(with isMale: Bool?) {
        guard let isMale = isMale else { return }

        if isMale {
            maleButton.layer.borderColor = borderColor
            femaleButton.layer.borderColor = UIColor.clear.cgColor
        } else {
            femaleButton.layer.borderColor = borderColor
            maleButton.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
