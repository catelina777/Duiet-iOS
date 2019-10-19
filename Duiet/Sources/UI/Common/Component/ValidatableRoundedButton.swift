//
//  ValidatableRoundedButton.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/10/18.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class ValidatableRoundedButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                backgroundColor = R.color.componentMain()!
            } else {
                backgroundColor = .systemGray
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
    }
}
