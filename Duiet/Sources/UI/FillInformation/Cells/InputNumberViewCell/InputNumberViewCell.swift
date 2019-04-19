//
//  InputNumberViewCell.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift

final class InputNumberViewCell: RxTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: MyTextField! {
        didSet {
            textField.font = R.font.montserratExtraBold(size: 24)
            textField.layer.cornerRadius = 10
            textField.layer.masksToBounds = true
        }
    }

    func configure(with cellType: CellType) {
        titleLabel.text = cellType.rawValue
        textField.keyboardType = .decimalPad
    }
}
