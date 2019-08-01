//
//  MonthSummaryViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/09.
//  Copyright © 2019 Duiet. All rights reserved.
//

import UIKit

final class MonthSummaryViewCell: RxCollectionViewCell {
    var viewModel: MonthSummaryViewModel!
    var dataSource: MonthSummaryViewDataSource!
    @IBOutlet private(set) weak var collectionView: UICollectionView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weightChangeLabel: UILabel!

    func configure(with month: Month) {
        self.viewModel = MonthSummaryViewModel(month: month, userInfoModel: UserInfoModel.shared)
        self.dataSource = MonthSummaryViewDataSource(viewModel: viewModel)
        dataSource.configure(with: collectionView)
        dayLabel.text = month.createdAt.toYearMonthString()
        let tdee = viewModel.userInfoModel.userInfo.value.TDEE
        let totalDifferenceGram = month.days.reduce(into: 0) { $0 += $1.totalCalorie - tdee }
        let weightChange = totalDifferenceGram / (9 * 0.8) / 1_000
        let weightChangeText = weightChange > 0 ?
            "+\(abs(round(weightChange * 100) / 100)) kg 💪" :
            "-\(abs(round(weightChange * 100) / 100)) kg ⬇️"
        weightChangeLabel.text = weightChangeText
    }
}
