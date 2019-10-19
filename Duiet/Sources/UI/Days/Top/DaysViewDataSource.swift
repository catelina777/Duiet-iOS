//
//  DaysViewDataSource.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/16.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class DaysViewDataSource: NSObject {
    private let viewModel: DaysViewModelProtocol

    init(viewModel: DaysViewModelProtocol) {
        self.viewModel = viewModel
    }

    func configure(with colletionView: UICollectionView) {
        colletionView.delegate = self
        colletionView.dataSource = self
        colletionView.register(R.nib.daySummaryViewCell)
    }
}

extension DaysViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        viewModel.state.daysValue.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.daySummaryViewCell,
                                                      for: indexPath)!
        cell.configure(with: viewModel.state.daysValue[indexPath.row],
                       userInfo: viewModel.state.userInfoValue,
                       unitCollection: viewModel.state.unitCollectionValue)
        return cell
    }
}

extension DaysViewDataSource: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let day = viewModel.state.daysValue[indexPath.row]
        viewModel.input.selectedDay.on(.next(day))
    }
}

extension DaysViewDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width * 0.9
        let height = width * 0.5
        let size = CGSize(width: width, height: height)
        return size
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let margin = collectionView.frame.width * 0.1 / 2
        let edgeInset = UIEdgeInsets(top: margin,
                                     left: 0,
                                     bottom: margin,
                                     right: 0)
        return edgeInset
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        collectionView.frame.width * 0.1 / 2
    }
}
