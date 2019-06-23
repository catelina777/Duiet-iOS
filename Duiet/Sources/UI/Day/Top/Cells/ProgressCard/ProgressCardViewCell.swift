//
//  ProgressCardViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/04/29.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ProgressCardViewCell: RxCollectionViewCell {

    @IBOutlet weak var TDEELabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var differenceLabel: UILabel!
    @IBOutlet weak var weightChangeLabel: UILabel!

    func configure(with progress: Observable<(Double, Double)>) {
        progress
            .bind(to: bindLabel)
            .disposed(by: disposeBag)
    }

    var bindLabel: Binder<(Double, Double)> {
        return Binder(self) { me, progress in
            let tdee = progress.0
            let total = progress.1
            let difference = tdee - total
            let weightChange = difference / 9
            me.TDEELabel.text = "\(Int(tdee)) kcal"
            me.totalLabel.text = "\(Int(total)) kcal"
            me.differenceLabel.text = "\(Int(difference)) kcal"
            me.weightChangeLabel.text = "\(Int(weightChange)) g"
        }
    }
}
