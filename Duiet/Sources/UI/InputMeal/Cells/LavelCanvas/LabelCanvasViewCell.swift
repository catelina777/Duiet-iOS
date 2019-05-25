//
//  LabelCanvasViewCell.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/05/09.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class LabelCanvasViewCell: RxTableViewCell {

    func configure(with viewModel: InputMealViewModel) {
        self.rx
            .longPressGesture()
            .when(.began)
            .asLocation()
            .map { [weak self] point -> MealLabelView? in
                guard let self = self else { return nil }
                let mealLableView = R.nib.mealLabelView.firstView(owner: nil)!
                mealLableView.configure(with: self, at: point)
                return mealLableView
            }
            .bind(to: viewModel.input.addMealLabel)
            .disposed(by: disposeBag)
    }
}
