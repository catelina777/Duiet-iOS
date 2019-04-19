//
//  CompleteButtonViewCell.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/19.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class CompleteButtonViewCell: RxTableViewCell {

    @IBOutlet weak var completeButton: UIButton! {
        didSet {
            completeButton.layer.cornerRadius = 10
        }
    }
}
