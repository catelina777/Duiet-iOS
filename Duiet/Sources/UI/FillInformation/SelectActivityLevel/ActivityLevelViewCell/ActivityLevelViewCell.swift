//
//  ActivityLevelViewCell.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/18.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class ActivityLevelViewCell: UITableViewCell {

    @IBOutlet weak var activityLevelLabel: UILabel!

    func configure(with level: ActivityLevel) {
        activityLevelLabel.text = level.description
    }
}
