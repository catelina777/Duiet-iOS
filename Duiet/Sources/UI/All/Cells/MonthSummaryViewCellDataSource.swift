//
//  MonthSummaryViewCellDataSource.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/09.
//  Copyright © 2019 duiet. All rights reserved.
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
        colletionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "kusa")
    }
}

extension MonthSummaryViewDataSource: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.progress.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kusa", for: indexPath)
        cell.backgroundColor = viewModel.progress[indexPath.row].color
        return cell
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
        return 0.01
    }
}
