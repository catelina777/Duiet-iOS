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

        cell.configure(with: contents[indexPath.row])
        return cell
    }
}

extension SuggestionDataSource: UICollectionViewDelegate {}

extension SuggestionDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard
            let contents = viewModel.state.suggestedContents,
            contents.count >= indexPath.row
        else { return .zero }

        let content = contents[indexPath.row]
        let nameLength = content.name.count
        let size = CGSize(width: 40 + (nameLength - 2) * 12, height: 32)
        return size
    }
}
