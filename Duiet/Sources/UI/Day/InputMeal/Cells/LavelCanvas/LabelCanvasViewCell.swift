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

    func configure(with viewModel: NewInputMealViewModel) {

        // MARK: - Show labels from stored contents
        viewModel.output.showLabelsOnce
            .map { $0.map { $0.convert() } }
            .subscribe(onNext: { [weak self] labels in
                guard let me = self else { return }
                let width = me.frame.width
                let height = me.frame.height
                labels.forEach { label in
                    let centerX = CGFloat(label.viewModel.content.relativeX) * width
                    let centerY = CGFloat(label.viewModel.content.relativeY) * height
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
            .map { [weak self] point -> Content? in
                guard let me = self else { return nil }
                let mealLabel = R.nib.mealLabelView.firstView(owner: nil)!
                let labelWidth = me.frame.width * 0.3
                let labelHeight = labelWidth * 0.4
                let labelFrame = CGRect(x: point.x - labelWidth / 2,
                                        y: point.y - labelHeight / 2,
                                        width: labelWidth,
                                        height: labelHeight)
                let relativeX = Double(point.x / me.frame.width)
                let relativeY = Double(point.y / me.frame.height)
                let content = Content(relativeX: relativeX, relativeY: relativeY)
                mealLabel.initialize(with: content)
                mealLabel.frame = labelFrame
                mealLabel.configure(with: viewModel)
                me.addSubview(mealLabel)
                return content
            }
            .compactMap { $0 }
            .bind(to: viewModel.input.contentWillAdd)
            .disposed(by: disposeBag)
    }
}
