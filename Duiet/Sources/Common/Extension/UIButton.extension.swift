//
//  UIButton.extension.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/18.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

extension UIButton {
    func configureGender() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
    }
}
