//
//  DayViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/16.
//  Copyright © 2019 Duiet. All rights reserved.
//

import UIKit

final class DayViewCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!

    func configure(with text: String) {
        textLabel.text = text

        // MARK: Apply theme
        backgroundColor = AppAppearance.shared.themeService.attrs.backgroundMainColor
    }
}
