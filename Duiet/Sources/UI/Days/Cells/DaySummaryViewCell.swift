//
//  DaySummaryViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/16.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class DaySummaryViewCell: RxRoundedCollectionViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var TDEELabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var differenceLabel: UILabel!
    @IBOutlet weak var weightChangeLabel: UILabel!

    func configure(with day: Day, userInfo: UserInfo) {
        let tdee = Int(userInfo.TDEE)
        let totalCalorie = Int(day.totalCalorie)
        let difference = Double(totalCalorie - tdee)
        let weightChange = Int(difference / (9 * 0.8))
        let weightChangeText = weightChange > 0 ?
            "\(abs(weightChange)) g UP 💪" :
            "\(abs(weightChange)) g DOWN ⬇️"
        dayLabel.text = "\(day.createdAt.toString())"
        TDEELabel.text = "\(tdee) kcal"
        totalLabel.text = "\(totalCalorie) kcal"
        differenceLabel.text = "\(difference) kcal"
        weightChangeLabel.text = weightChangeText
    }
}
