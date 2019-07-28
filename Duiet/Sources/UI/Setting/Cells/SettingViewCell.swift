//
//  SettingViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/08.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class SettingViewCell: UICollectionViewCell {

    @IBOutlet weak var roundedView: UIView!

    @IBOutlet weak var titleLabel: UILabel!

    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                UIView.animate(withDuration: 0.1) {
                    self.roundedView.backgroundColor = R.color.highlight()
                }
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.roundedView.backgroundColor = R.color.contentBackground()
                }
            }
        }
    }

    func configure(with type: SettingType) {
        titleLabel.text = type.contentText
    }
}
