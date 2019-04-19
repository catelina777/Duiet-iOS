//
//  RxTableViewCell.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/18.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift

enum CellType: String {
    case gender = "Gender"
    case height = "Height(cm)"
    case weight = "Weight(kg)"
    case activityLevel = "Activity Level"
    case complete
}

class RxTableViewCell: UITableViewCell {

    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
}
