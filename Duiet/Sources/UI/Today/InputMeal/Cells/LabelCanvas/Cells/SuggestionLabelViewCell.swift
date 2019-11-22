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

    func configure(foodEntity: FoodEntity) {
        suggestionName.text = foodEntity.name
        contentView.translatesAutoresizingMaskIntoConstraints = false
        switchSelected.on(.next(false))
    }

    func bindIsChecked(input: LabelCanvasViewModelInput, output: LabelCanvasViewModelOutput, foodEntity: FoodEntity) {
        rx.tapGesture()
            .when(.ended)
            .map { _ in foodEntity }
            .bind(to: input.suggestionDidSelect)
            .disposed(by: disposeBag)

        output.suggestionDidSelect
            .map { $0 == foodEntity }
            .bind(to: switchSelected)
            .disposed(by: disposeBag)
    }
}
