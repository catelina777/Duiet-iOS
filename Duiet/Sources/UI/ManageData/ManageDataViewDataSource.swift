//
//  ManageDataViewDataSource.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/23.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class ManageDataViewDataSource: NSObject {
    private let viewModel: ManageDataViewModelProtocol

    init(viewModel: ManageDataViewModelProtocol) {
        self.viewModel = viewModel
    }

    func configure(with collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(R.nib.explainCardViewCell)
    }
}

extension ManageDataViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ManageDataType.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.explainCardViewCell,
                                                      for: indexPath)!
        cell.configure(type: ManageDataType.allCases[indexPath.row])
        return cell
    }
}

extension ManageDataViewDataSource: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        viewModel.input.itemDidSelect.onNext(ManageDataType.allCases[indexPath.row])
    }
}

extension ManageDataViewDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard
            let cell = Bundle.main.loadNibNamed(ExplainCardViewCell.className,
                                                owner: self,
                                                options: nil)?.first as? ExplainCardViewCell
        else { return CGSize.zero }
        cell.configure(type: ManageDataType.allCases[indexPath.row])
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let width = collectionView.frame.width * 0.9
        let size = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: width, height: size.height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let margin = collectionView.frame.width * 0.1 / 2
        return UIEdgeInsets(top: margin, left: 0, bottom: margin, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        collectionView.frame.width * 0.1 / 2
    }
}
