//
//  YearViewDataSource.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/09.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class YearViewDataSource: NSObject {

    private let viewModel: YearViewModel

    init(viewModel: YearViewModel) {
        self.viewModel = viewModel
    }

    func configure(with colletionView: UICollectionView) {
        colletionView.delegate = self
        colletionView.dataSource = self
        colletionView.register(R.nib.monthSummaryViewCell)
    }
}

extension YearViewDataSource: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.months.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.monthSummaryViewCell,
                                                      for: indexPath)!
        let month = viewModel.months[indexPath.row]
        cell.configure(with: month)
        return cell
    }
}

extension YearViewDataSource: UICollectionViewDelegate {}

extension YearViewDataSource: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.frame.width * 0.425
        let height = width * 1.2
        let size = CGSize(width: width, height: height)
        return size
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let space = collectionView.frame.width * 0.15 / 3
        let edgeInset = UIEdgeInsets(top: space,
                                     left: space,
                                     bottom: space,
                                     right: space)
        return edgeInset
    }

    // MARK: It is set to make sure that there is no shadow line
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let space = collectionView.frame.width * 0.15 / 3
        return space
    }
}
