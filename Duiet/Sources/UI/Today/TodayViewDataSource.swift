//
//  TodayViewDataSource.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/23.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TodayViewDataSource: NSObject {

    private let viewModel: TodayViewModel

    init(viewModel: TodayViewModel) {
        self.viewModel = viewModel
    }

    func configure(with collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(R.nib.mealCardViewCell)
    }
}

extension TodayViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.mealCardViewCell,
                                                      for: indexPath)!
        return cell
    }
}

extension TodayViewDataSource: UICollectionViewDelegate {}

extension TodayViewDataSource: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = width * 0.985
        let size = CGSize(width: width,
                          height: height)
        return size
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let edgeInset = UIEdgeInsets(top: collectionView.frame.width * 0.1 / 2,
                                     left: 0,
                                     bottom: 0,
                                     right: 0)
        return edgeInset
    }

    // MARK: It is set to make sure that there is no shadow line
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.01
    }
}
