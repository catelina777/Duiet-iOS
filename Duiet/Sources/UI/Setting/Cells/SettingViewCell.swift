//
//  SettingViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/08.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class SettingViewCell: RxRoundedCollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(with type: SettingType) {
        titleLabel.text = type.contentText
    }
}
