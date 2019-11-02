//
//  RoundedCollectionViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/08/10.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

class RoundedCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak var roundedView: UIView!

    override var isHighlighted: Bool {
        willSet {
            if newValue {
                UIView.animate(withDuration: 0.1) {
                    self.roundedView.backgroundColor = R.color.cellHighlight()!
                }
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.roundedView.backgroundColor = R.color.cellBackground()!
                }
            }
        }

        didSet {
            Haptic.impact(.light).generate()
        }
    }
}
