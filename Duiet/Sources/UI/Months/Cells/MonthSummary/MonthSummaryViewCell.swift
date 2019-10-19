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
        let localizedWeightChangeValue = UnitLocalizeHelper.shared.convertRoundedWithSymbol(value: weightChange,
                                                                                            from: .kilograms,
                                                                                            to: .kilograms,
                                                                                            significantDigits: 3)
        let weightChangeText = weightChange > 0 ?
            "+\(localizedWeightChangeValue) 💪" :
            "-\(localizedWeightChangeValue) ⬇️"
        weightChangeLabel.text = weightChangeText
    }
}
