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
        let tdee = Int(userInfo.TDEE)
        let totalCalorie = Int(day.totalCalorie)
        let difference = Double(totalCalorie - tdee)
        let weightChange = Int(difference / (9 * 0.8))
        let weightChangeText = weightChange > 0 ?
            "\(abs(weightChange)) \(R.string.localizable.g()) \(R.string.localizable.up()) 💪" :
            "\(abs(weightChange)) \(R.string.localizable.g()) \(R.string.localizable.down()) ⬇️"
        dayValueLabel.text = "\(day.createdAt.toString())"
        tdeeValueLabel.text = "\(tdee) \(R.string.localizable.kcal())"
        totalValueLabel.text = "\(totalCalorie) \(R.string.localizable.kcal())"
        differenceValueLabel.text = "\(difference) \(R.string.localizable.kcal())"
        weightChangeValueLabel.text = weightChangeText
    }
}
