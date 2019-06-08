//
//  RoundedTextFieldViewCell.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/05/15.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

class RoundedTextFieldViewCell: RxTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var textField: MyTextField! {
        didSet {
            textField.font = R.font.montserratExtraBold(size: 24)
            textField.layer.cornerRadius = 10
            textField.layer.masksToBounds = true
        }
    }
}
