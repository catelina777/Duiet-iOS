//
//  MonthSummaryViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/09.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class MonthSummaryViewCell: RxCollectionViewCell {

    var viewModel: MonthSummaryViewModel!
    var dataSource: MonthSummaryViewDataSource!
    @IBOutlet private(set) weak var collectionView: UICollectionView!

    func configure(with progress: [ProgressType]) {
        self.viewModel = MonthSummaryViewModel(progress: progress)
        self.dataSource = MonthSummaryViewDataSource(viewModel: viewModel)
        dataSource.configure(with: collectionView)
    }
}
