//
//  ProgressCardViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/04/29.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class ProgressCardViewCell: RxCollectionViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var TDEELabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var differenceLabel: UILabel!
    @IBOutlet weak var weightChangeLabel: UILabel!

    func configure(with progress: Observable<(Day, UserInfo)>) {
       progress
            .bind(to: bindLabels)
            .disposed(by: disposeBag)
    }

    var bindLabels: Binder<(Day, UserInfo)> {
        return Binder(self) { me, progress in
            let tdee = Int(progress.1.TDEE)
            let totalCalorie = Int(progress.0.totalCalorie)
            let difference = Double(totalCalorie - tdee)
            let weightChange = Int(difference / (9 * 0.8))
            let weightChangeText = weightChange > 0 ?
                "\(abs(weightChange)) g UP 💪" :
                "\(abs(weightChange)) g DOWN ⬇️"
            me.dayLabel.text = "\(progress.0.createdAt.toString())"
            me.TDEELabel.text = "\(tdee) kcal"
            me.totalLabel.text = "\(totalCalorie) kcal"
            me.differenceLabel.text = "\(difference) kcal"
            me.weightChangeLabel.text = weightChangeText
        }
    }
}
