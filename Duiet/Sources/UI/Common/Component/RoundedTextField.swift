//
//  RoundedTextField.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/18.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class RoundedTextField: UITextField {
    override func layoutSubviews() {
        super.layoutSubviews()
        font = R.font.montserratExtraBold(size: 24)
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: 16.0, dy: 0.0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: 16.0, dy: 0.0)
    }
}
