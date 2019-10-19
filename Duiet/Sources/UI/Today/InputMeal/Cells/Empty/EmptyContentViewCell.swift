//
//  EmptyContentViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/05/25.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class EmptyContentViewCell: BaseTableViewCell {
    @IBOutlet private weak var placeholderLabel: UILabel! {
        didSet { placeholderLabel.text = R.string.localizable.inputIntroduction() }
    }
}
