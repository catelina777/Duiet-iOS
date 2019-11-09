//
//  UIView.extension.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/18.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

extension UIView {
    func makeEdges(cornerRadius: CGFloat, borderWidth: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = UIColor.clear.cgColor
        layer.masksToBounds = true
    }
}
