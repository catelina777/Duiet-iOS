//
//  SettingViewDataSource.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/08.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class SettingViewDataSource: NSObject {

    private let viewModel: SettingViewModel

    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
    }

    func configure(with collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(R.nib.settingViewCell)
    }
}

extension SettingViewDataSource: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return SettingType.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.settingViewCell,
                                                      for: indexPath)!
        let selectionType = SettingType.allCases[indexPath.row]
        cell.configure(with: selectionType)
        return cell
    }
}

extension SettingViewDataSource: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let selectionType = SettingType.allCases[indexPath.row]
        viewModel.input.itemDidSelect.on(.next(selectionType))
    }
}

extension SettingViewDataSource: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.frame.width * 0.9
        let height = width * 0.175
        let size = CGSize(width: width, height: height)
        return size
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let space = collectionView.frame.width * 0.1 / 2
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
        let space = collectionView.frame.width * 0.1 / 2
        return space
    }
}
