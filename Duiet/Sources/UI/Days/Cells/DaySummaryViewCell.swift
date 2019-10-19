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

    func configure(with day: Day, userInfo: UserInfo) {
        let tdee = userInfo.TDEE
        let totalCalorie = day.totalCalorie
        let difference = totalCalorie - tdee
        let weightChange = difference / (9 * 0.8)
        let localizeWeightChangeValueWithSymbol = UnitLocalizeHelper.shared.convertWithSymbol(value: abs(weightChange),
                                                                                              from: .kilograms,
                                                                                              to: .kilograms)
        let weightChangeText = weightChange > 0 ?
            "\(localizeWeightChangeValueWithSymbol) \(R.string.localizable.up()) 💪" :
            "\(localizeWeightChangeValueWithSymbol) \(R.string.localizable.down()) ⬇️"

        dayValueLabel.text = day.createdAt.toString()
        tdeeValueLabel.text = UnitLocalizeHelper.shared.convertWithSymbol(value: tdee,
                                                                          from: .kilocalories,
                                                                          to: .kilocalories)
        totalValueLabel.text = UnitLocalizeHelper.shared.convertWithSymbol(value: totalCalorie,
                                                                           from: .kilocalories,
                                                                           to: .kilocalories)
        differenceValueLabel.text = UnitLocalizeHelper.shared.convertWithSymbol(value: difference,
                                                                                from: .kilocalories,
                                                                                to: .kilocalories)
        weightChangeValueLabel.text = weightChangeText
    }
}
