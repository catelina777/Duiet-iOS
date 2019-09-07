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
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.1) {
                    self.roundedView.backgroundColor = R.color.highlight()
                }
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.roundedView.backgroundColor = R.color.mainBackground()
                }
            }
        }
    }
}
