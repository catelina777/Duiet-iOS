//
//  AddMealCardViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/09.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class AddMealCardViewCell: BaseCollectionViewCell {
    @IBOutlet private weak var addMealButton: UIButton!

    func configure(input: TodayViewModelInput) {
        addMealButton.rx.tap
            .bind(to: input.addButtonDidTap)
            .disposed(by: disposeBag)
    }
}
