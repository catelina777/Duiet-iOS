//
//  RxCollectionViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/04/29.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift

class RxCollectionViewCell: UICollectionViewCell {

    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
}
