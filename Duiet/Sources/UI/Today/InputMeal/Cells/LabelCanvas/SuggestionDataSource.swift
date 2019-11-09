//
//  SuggestionDataSource.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/04.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class SuggestionDataSource: NSObject {
    private let viewModel: LabelCanvasViewModelProtocol

    init(viewModel: LabelCanvasViewModelProtocol) {
        self.viewModel = viewModel
    }

    func configure(with collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(R.nib.suggestionLabelViewCell)
    }
}

extension SuggestionDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.state.suggestedContents?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.suggestionLabelViewCell,
                                                      for: indexPath)!

        guard
            let contents = viewModel.state.suggestedContents,
            contents.count >= indexPath.row
        else { return cell }

        cell.configure(content: contents[indexPath.row])
        cell.bindIsChecked(input: viewModel.input,
                           output: viewModel.output,
                           content: contents[indexPath.row])
        return cell
    }
}

extension SuggestionDataSource: UICollectionViewDelegate {}

extension SuggestionDataSource: UICollectionViewDelegateFlowLayout {
    /// Change the size of the label according to the length of the characters to be displayed
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard
            let cell = Bundle.main.loadNibNamed(SuggestionLabelViewCell.className,
                                                owner: self,
                                                options: nil)?.first as? SuggestionLabelViewCell,
            let contents = viewModel.state.suggestedContents
        else { return CGSize.zero }
        cell.configure(content: contents[indexPath.row])
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let size = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: size.width, height: 30)
    }
}
