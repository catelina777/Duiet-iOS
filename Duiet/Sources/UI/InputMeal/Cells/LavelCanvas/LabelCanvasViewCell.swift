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

        // MARK: - Show stored labels
        viewModel.output.showLabelViews
            .map { $0.convert(with: viewModel, view: self) }
            .subscribe(onNext: { _ in
                print("show labels")
            })
            .disposed(by: disposeBag)

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
                print("長押し")
                print("初期値は")
                print(mealLabelView.content.value)
                viewModel.input.saveContent.on(.next(mealLabelView.content.value))
                viewModel.input.selectedMealLabel.on(.next(mealLabelView))
                print("追加された値は")
                print(mealLabelView.content.value)
                return mealLabelView
            }
            .compactMap { $0 }
            .bind(to: viewModel.input.addMealLabel)
            .disposed(by: disposeBag)
    }
}
