//
//  InputActivityLevelViewCell.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/18.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class InputActivityLevelViewCell: RxTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var textField: MyTextField! {
        didSet {
            textField.font = R.font.montserratExtraBold(size: 24)
            textField.layer.cornerRadius = 10
            textField.layer.masksToBounds = true
            textField.isEnabled = false
        }
    }

    func configure(with cellType: CellType) {
        titleLabel.text = cellType.rawValue
    }
}
