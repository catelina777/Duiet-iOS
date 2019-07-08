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

    // TODO: - The code here is almost a memory leak, so it needs to be improved
    func configure(with viewModel: InputMealViewModel) {

        // MARK: - Show stored labels

        /*
         1. List<Content>を[MealLabelView]に変換する
            1. contentを渡してframeの設定
            2. 渡したcontentをmealLabelviewのcontentに通知する
            3. mealLabelViewのtextにカロリーの値を渡す
         2. MealLabelViewとviewModelの設定を行う
            1. タッチしたときに選択したmealLabelとしてviewModeに通知
            2. タッチしたとに編集した際の値の変更をviewModelに通知
            3. MealLabelViewをcanvasに追加する
         */

        viewModel.output.showLabelViews
            .map { $0.map { $0.convert() }}
            .subscribe(onNext: { [weak self] labels in
                guard let me = self else { return }
                let width = me.frame.width
                let height = me.frame.height
                labels.forEach { label in
                    let centerX = CGFloat(label.content.value.relativeX) * width
                    let centerY = CGFloat(label.content.value.relativeY) * height
                    let labelWidth = width * 0.3
                    let labelHeight = labelWidth * 0.4
                    let labelFrame = CGRect(x: centerX - labelWidth / 2,
                                            y: centerY - labelHeight / 2,
                                            width: labelWidth,
                                            height: labelHeight)
                    label.frame = labelFrame
                    label.configure(with: viewModel)
                    me.addSubview(label)
                }
            })
            .disposed(by: disposeBag)

        self.rx
            .longPressGesture()
            .when(.began)
            .asLocation()
            .map { [weak self] point -> MealLabelView? in
                guard let me = self else { return nil }
                // Create a view and add it to the parent view
                // After that, save the content model that the view has,
                // and perform processing to pass the Content Model to the view model when tapping
                let mealLabelView = R.nib.mealLabelView.firstView(owner: nil)!
                let labelWidth = me.frame.width * 0.3
                let labelHeight = labelWidth * 0.4
                let labelFrame = CGRect(x: point.x - labelWidth / 2,
                                        y: point.y - labelHeight / 2,
                                        width: labelWidth,
                                        height: labelHeight)
                let relativeX = Double(point.x / me.frame.width)
                let relativeY = Double(point.y / me.frame.height)
                let content = Content(relativeX: relativeX, relativeY: relativeY)
                mealLabelView.configure(with: content)
                mealLabelView.frame = labelFrame
                mealLabelView.configure(with: viewModel)
                me.addSubview(mealLabelView)
                viewModel.input.saveContent.on(.next(mealLabelView.content.value))
                viewModel.input.selectedMealLabel.on(.next(mealLabelView))
                return mealLabelView
            }
            .compactMap { $0 }
            .bind(to: viewModel.input.addMealLabel)
            .disposed(by: disposeBag)
    }
}
