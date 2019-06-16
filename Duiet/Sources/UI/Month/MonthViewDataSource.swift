//
//  MonthViewDataSource.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/16.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class MonthViewDataSource: NSObject {

    private let viewModel: MonthViewModel

    init(viewModel: MonthViewModel) {
        self.viewModel = viewModel
    }

    func configure(with colletionView: UICollectionView) {
        colletionView.delegate = self
        colletionView.dataSource = self
    }
}

extension MonthViewDataSource: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        return cell
    }
}

extension MonthViewDataSource: UICollectionViewDelegate {}

extension MonthViewDataSource: UICollectionViewDelegateFlowLayout {}
