//
//  RoundedWrapperView.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/15.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class RoundedWrapperView: UIView {

    @IBOutlet weak var roundedView: UIView!

    override func layoutSubviews() {
        super.layoutSubviews()
        roundedView.layer.cornerRadius = 12
        roundedView.clipsToBounds = true
    }
}
