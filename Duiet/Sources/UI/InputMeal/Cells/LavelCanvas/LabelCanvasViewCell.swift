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
                // Create a view and add it to the parent view
                // After that, save the content model that the view has,
                // and perform processing to pass the Content Model to the view model when tapping
                let mealLabelView = R.nib.mealLabelView.firstView(owner: nil)!
                mealLabelView.configure(with: self, at: point)
                mealLabelView.configure(with: viewModel)
                viewModel.input.saveContent.on(.next(mealLabelView.content))
                viewModel.input.selectedContent.on(.next(mealLabelView.content))
                return mealLabelView
            }
            .bind(to: viewModel.input.addMealLabel)
            .disposed(by: disposeBag)
    }
}
