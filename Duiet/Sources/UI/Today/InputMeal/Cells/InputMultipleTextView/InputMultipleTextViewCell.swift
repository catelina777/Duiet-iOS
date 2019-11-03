//
//  InputMultipleTextViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/03.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class InputMultipleTextViewCell: BaseTableViewCell {
    @IBOutlet private weak var titleLabel1: UILabel! {
        didSet { titleLabel1.text = R.string.localizable.energy() }
    }

    @IBOutlet private weak var titleLabel2: UILabel! {
        didSet { titleLabel2.text = R.string.localizable.multiple() }
    }

    @IBOutlet private weak var textField1: RoundedTextField!
    @IBOutlet private weak var textField2: RoundedTextField!
}
