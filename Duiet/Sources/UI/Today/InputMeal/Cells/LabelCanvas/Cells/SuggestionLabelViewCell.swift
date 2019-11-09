//
//  SuggestionLabelViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/04.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxCocoa
import UIKit

final class SuggestionLabelViewCell: BaseCollectionViewCell {
    @IBOutlet private weak var suggestionName: UILabel!

    var switchSelected: Binder<Bool> {
        Binder<Bool>(self) { me, isSelected in
            if isSelected {
                me.contentView.makeEdges(cornerRadius: 15, borderWidth: 2.5)
                me.contentView.layer.borderColor = R.color.componentMain()?.cgColor
            } else {
                me.contentView.makeEdges(cornerRadius: 15, borderWidth: 1)
                me.contentView.layer.borderColor = UIColor.secondaryLabel.cgColor
            }
        }
    }

    func configure(content: Content) {
        suggestionName.text = content.name
        contentView.translatesAutoresizingMaskIntoConstraints = false
        switchSelected.on(.next(false))
    }

    func bindIsChecked(input: LabelCanvasViewModelInput, output: LabelCanvasViewModelOutput, content: Content) {
        rx.tapGesture()
            .when(.ended)
            .map { _ in content }
            .bind(to: input.suggestionDidSelect)
            .disposed(by: disposeBag)

        output.suggestionDidSelect
            .map { $0 == content }
            .bind(to: switchSelected)
            .disposed(by: disposeBag)
    }
}
