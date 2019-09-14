//
//  MonthSummaryViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/09.
//  Copyright © 2019 Duiet. All rights reserved.
//

import UIKit

final class MonthSummaryViewCell: RoundedCollectionViewCell {
    var viewModel: MonthSummaryViewModelProtocol!
    var dataSource: MonthSummaryViewDataSource!
    @IBOutlet private(set) weak var collectionView: UICollectionView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weightChangeLabel: UILabel!

    func configure(with month: Month) {
        viewModel = MonthSummaryViewModel(month: month, userInfoModel: UserInfoModel.shared)
        dataSource = MonthSummaryViewDataSource(viewModel: viewModel)
        dataSource.configure(with: collectionView)
        dayLabel.text = month.createdAt.toYearMonthString()
        let tdee = viewModel.data.userInfo.TDEE
        let totalDifferenceGram = month.days.reduce(into: 0) { $0 += $1.totalCalorie - tdee }
        let weightChange = totalDifferenceGram / (9 * 0.8) / 1_000
        let weightChangeText = weightChange > 0 ?
            "+\(abs(round(weightChange * 100) / 100)) kg 💪" :
            "-\(abs(round(weightChange * 100) / 100)) kg ⬇️"
        weightChangeLabel.text = weightChangeText

        // MARK: Apply theme
        let theme = AppAppearance.shared.themeService.attrs
        roundedView.backgroundColor = theme.cellBackgroundColor
        collectionView.backgroundColor = theme.cellBackgroundColor
        dayLabel.textColor = theme.textMainColor
        weightChangeLabel.textColor = theme.textMainColor
    }
}
