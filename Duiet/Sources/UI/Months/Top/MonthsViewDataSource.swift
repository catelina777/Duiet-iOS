//
//  MonthsViewDataSource.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/09.
//  Copyright © 2019 Duiet. All rights reserved.
//

import UIKit

final class MonthsViewDataSource: NSObject {
    private let viewModel: MonthsViewModelProtocol

    init(viewModel: MonthsViewModelProtocol) {
        self.viewModel = viewModel
    }

    func configure(with colletionView: UICollectionView) {
        colletionView.delegate = self
        colletionView.dataSource = self
        colletionView.register(R.nib.monthSummaryViewCell)
    }
}

extension MonthsViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        viewModel.state.monthsValue.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.monthSummaryViewCell,
                                                      for: indexPath)!
        let monthEntity = viewModel.state.monthsValue[indexPath.row]
        cell.configure(month: Month(entity: monthEntity))
        return cell
    }
}

extension MonthsViewDataSource: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let month = viewModel.state.monthsValue[indexPath.row]
        viewModel.input.itemDidSelect.on(.next(month))
    }
}

extension MonthsViewDataSource: UICollectionViewDelegateFlowLayout {
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
