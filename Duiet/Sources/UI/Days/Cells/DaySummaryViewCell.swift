//
//  DaySummaryViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/16.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class DaySummaryViewCell: RoundedCollectionViewCell {
    @IBOutlet weak var dayValueLabel: UILabel!
    @IBOutlet weak var TDEEValueLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var differenceValueLabel: UILabel!
    @IBOutlet weak var weightChangeValueLabel: UILabel!

    func configure(with day: Day, userInfo: UserInfo) {
        let tdee = Int(userInfo.TDEE)
        let totalCalorie = Int(day.totalCalorie)
        let difference = Double(totalCalorie - tdee)
        let weightChange = Int(difference / (9 * 0.8))
        let weightChangeText = weightChange > 0 ?
            "\(abs(weightChange)) g UP 💪" :
            "\(abs(weightChange)) g DOWN ⬇️"
        dayValueLabel.text = "\(day.createdAt.toString())"
        TDEEValueLabel.text = "\(tdee) kcal"
        totalValueLabel.text = "\(totalCalorie) kcal"
        differenceValueLabel.text = "\(difference) kcal"
        weightChangeValueLabel.text = weightChangeText
    }
}
