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

final class ProgressCardViewCell: BaseCollectionViewCell {
    @IBOutlet weak var tdeeLabel: UILabel! {
        didSet { tdeeLabel.text = R.string.localizable.tdee() }
    }
    @IBOutlet weak var calorieIntakeLabel: UILabel! {
        didSet { calorieIntakeLabel.text = R.string.localizable.calorieIntake() }
    }
    @IBOutlet weak var differenceLabel: UILabel! {
        didSet { differenceLabel.text = R.string.localizable.difference() }
    }
    @IBOutlet weak var weightChangeLabel: UILabel! {
        didSet { weightChangeLabel.text = R.string.localizable.weightChange() }
    }

    @IBOutlet weak var dayValueLabel: UILabel!
    @IBOutlet weak var TDEEValueLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var differenceValueLabel: UILabel!
    @IBOutlet weak var weightChangeValueLabel: UILabel!

    func configure(with progress: Observable<(Day, UserInfo)>) {
        progress
            .bind(to: bindLabels)
            .disposed(by: disposeBag)
    }

    var bindLabels: Binder<(Day, UserInfo)> {
        Binder(self) { me, progress in
            let tdee = Int(progress.1.TDEE)
            let totalCalorie = Int(progress.0.totalCalorie)
            let difference = Double(totalCalorie - tdee)
            let weightChange = Int(difference / (9 * 0.8))
            let weightChangeText = weightChange > 0 ?
                "\(abs(weightChange)) \(R.string.localizable.g()) \(R.string.localizable.up()) 💪" :
                "\(abs(weightChange)) \(R.string.localizable.g()) \(R.string.localizable.down()) ⬇️"
            me.dayValueLabel.text = "\(progress.0.createdAt.toString())"
            me.TDEEValueLabel.text = "\(tdee) \(R.string.localizable.kcal())"
            me.totalValueLabel.text = "\(totalCalorie) \(R.string.localizable.kcal())"
            me.differenceValueLabel.text = "\(difference) \(R.string.localizable.kcal())"
            me.weightChangeValueLabel.text = weightChangeText
        }
    }
}
