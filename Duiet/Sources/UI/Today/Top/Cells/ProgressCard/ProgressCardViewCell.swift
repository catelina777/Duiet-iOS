//
//  ProgressCardViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/04/29.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

class RoundedWrapperView: UIView {

    @IBOutlet weak var roundedView: UIView!

    override func layoutSubviews() {
        super.layoutSubviews()
        roundedView.layer.cornerRadius = 12
        roundedView.clipsToBounds = true
    }
}

final class ProgressCardViewCell: RxCollectionViewCell {

    func configure() {
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
    }
}
