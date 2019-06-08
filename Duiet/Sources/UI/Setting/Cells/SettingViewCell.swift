//
//  SettingViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/08.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class SettingViewCell: RxTableViewCell {

    @IBOutlet weak var roundedView: UIView! {
        didSet {
            roundedView.layer.cornerRadius = 10
            roundedView.clipsToBounds = true
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
}
