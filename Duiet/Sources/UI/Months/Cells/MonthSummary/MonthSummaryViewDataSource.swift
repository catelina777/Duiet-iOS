//
//  MonthSummaryViewCellDataSource.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/09.
//  Copyright © 2019 Duiet. All rights reserved.
//

import UIKit

final class MonthSummaryViewDataSource: NSObject {
    private let viewModel: MonthSummaryViewModel

    init(viewModel: MonthSummaryViewModel) {
        self.viewModel = viewModel
    }

    func configure(with colletionView: UICollectionView) {
        colletionView.delegate = self
        colletionView.dataSource = self
        colletionView.register(R.nib.dayViewCell)
        colletionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "kusa")
    }
}

extension MonthSummaryViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Week.all.count + viewModel.progress.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0..<Week.all.count:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.dayViewCell,
                                                          for: indexPath)!
            cell.configure(with: Week.all[indexPath.row].abbr)
            return cell

        default:
            let row = indexPath.row - Week.all.count
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kusa", for: indexPath)
            cell.backgroundColor = viewModel.progress[row].color
            return cell
        }
    }
}

extension MonthSummaryViewDataSource: UICollectionViewDelegate {}

extension MonthSummaryViewDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.layoutIfNeeded()
        let width = collectionView.frame.width / 8
        let height = width
        let size = CGSize(width: width, height: height)
        return size
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let width = collectionView.frame.width / 8
        let space = width / 7
        return space
    }

    // MARK: It is set to make sure that there is no shadow line
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let width = collectionView.frame.width / 8
        let space = width / 7
        return space
    }
}
