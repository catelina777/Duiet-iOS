//
//  DaySummaryViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/16.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class DaySummaryViewCell: RoundedCollectionViewCell {
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
    @IBOutlet weak var tdeeValueLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var differenceValueLabel: UILabel!
    @IBOutlet weak var weightChangeValueLabel: UILabel!

    func configure(with day: Day, userInfo: UserInfo, unitCollection: UnitCollection) {
        let tdee = userInfo.TDEE
        let totalCalorie = day.totalCalorie
        let difference = totalCalorie - tdee
        let weightChange = difference / (9 * 0.8) / 1_000
        let weightChangeValueWithSymbol = UnitBabel.shared.convertRoundedWithSymbol(value: abs(weightChange),
                                                                                    from: .kilograms,
                                                                                    to: unitCollection.weightUnit,
                                                                                    significantDigits: 3)
        let weightChangeText = weightChange > 0 ?
            "\(weightChangeValueWithSymbol) \(R.string.localizable.up()) 💪" :
            "\(weightChangeValueWithSymbol) \(R.string.localizable.down()) ⬇️"

        dayValueLabel.text = day.createdAt.toString()
        tdeeValueLabel.text = UnitBabel.shared.convertWithSymbol(value: tdee,
                                                                 from: .kilocalories,
                                                                 to: unitCollection.energyUnit)
        totalValueLabel.text = UnitBabel.shared.convertWithSymbol(value: totalCalorie,
                                                                  from: .kilocalories,
                                                                  to: unitCollection.energyUnit)
        differenceValueLabel.text = UnitBabel.shared.convertWithSymbol(value: difference,
                                                                       from: .kilocalories,
                                                                       to: unitCollection.energyUnit)
        weightChangeValueLabel.text = weightChangeText
    }
}
