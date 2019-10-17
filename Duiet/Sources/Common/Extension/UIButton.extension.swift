//
//  UIButton.extension.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/18.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

extension UIButton {
    func makeRoundCornersAndColorEdges() {
        layer.cornerRadius = 10
        layer.borderWidth = 4
        layer.borderColor = UIColor.clear.cgColor
        layer.masksToBounds = true
    }
}
