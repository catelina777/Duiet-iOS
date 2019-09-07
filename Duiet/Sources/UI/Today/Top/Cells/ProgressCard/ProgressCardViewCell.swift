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
    @IBOutlet weak var roundedView: UIView!

    @IBOutlet weak var TDEELabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var differenceLabel: UILabel!
    @IBOutlet weak var weightChangeLabel: UILabel!

    @IBOutlet weak var dayValueLabel: UILabel!
    @IBOutlet weak var TDEEValueLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var differenceValueLabel: UILabel!
    @IBOutlet weak var weightChangeValueLabel: UILabel!

    func configure(with progress: Observable<(Day, UserInfo)>) {
        progress
            .bind(to: bindLabels)
            .disposed(by: disposeBag)

        // MARK: Apply theme
        let theme = AppAppearance.shared.themeService.attrs
        roundedView.backgroundColor = theme.cellBackgroundColor
        dayValueLabel.textColor = theme.textMainColor
        TDEEValueLabel.textColor = theme.textMainColor
        totalValueLabel.textColor = theme.textMainColor
        differenceValueLabel.textColor = theme.textMainColor
        weightChangeValueLabel.textColor = theme.textMainColor

        TDEELabel.textColor = theme.textSubColor
        totalLabel.textColor = theme.textSubColor
        differenceLabel.textColor = theme.textSubColor
        weightChangeLabel.textColor = theme.textSubColor
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
            me.dayValueLabel.text = "\(progress.0.createdAt.toString())"
            me.TDEEValueLabel.text = "\(tdee) kcal"
            me.totalValueLabel.text = "\(totalCalorie) kcal"
            me.differenceValueLabel.text = "\(difference) kcal"
            me.weightChangeValueLabel.text = weightChangeText
        }
    }
}
