//
//  LabelCanvasViewCell.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/05/09.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxCocoa
import RxGesture
import RxSwift
import UIKit

final class LabelCanvasViewCell: BaseTableViewCell {
    @IBOutlet private weak var mealImageView: UIImageView!
    @IBOutlet private(set) weak var suggestionCollectionView: UICollectionView!

    private(set) var viewModel: LabelCanvasViewModelProtocol!
    private(set) var suggestionDataSource: SuggestionDataSource!

    // TODO: This code is terrible and should be refactored
    func configure(input: InputMealViewModelInput, output: InputMealViewModelOutput, state: InputMealViewModelState) {
        if !state.isShowedContents.value {
            show(foods: state.foods.map { Food(entity: $0) }, input: input)
            state.isShowedContents.accept(true)
        }
        bindSuggestedContent(input: input, output: output)
        suggestionDataSource.configure(with: suggestionCollectionView)
        bindAddContent(input: input)
        configure(with: state.foodImage)
    }

    private func show(foods: [Food], input: InputMealViewModelInput) {
        foods.map { MealLabelView.build(food: $0) }.forEach { label in
            let food = label.viewModel.state.foodValue
            let centerX = CGFloat(food.relativeX) * frame.width
            let centerY = CGFloat(food.relativeY) * frame.height
            let labelWidth = frame.width * 0.3
            let labelHeight = labelWidth * 0.4
            let labelFrame = CGRect(x: centerX - labelWidth / 2,
                                    y: centerY - labelHeight / 2,
                                    width: labelWidth,
                                    height: labelHeight)
            label.frame = labelFrame
            label.configure(input: input)
            addSubview(label)
        }
    }

    /// Monitor screen presses and add content
    /// - Parameter input: ViewModel input
    private func bindAddContent(input: InputMealViewModelInput) {
        rx
            .longPressGesture()
            .when(.began)
            .asLocation()
            .map { [weak self] point -> MealLabelView? in
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
                let food = Food(relativeX: relativeX, relativeY: relativeY)
                mealLabel.initialize(with: food)
                mealLabel.frame = labelFrame
                mealLabel.configure(input: input)
                me.addSubview(mealLabel)
                return mealLabel
            }
            .compactMap { $0 }
            .subscribe(onNext: { mealLabel in
                input.selectedLabelViewModel.on(.next(mealLabel.viewModel))
                input.contentWillAdd.on(.next(mealLabel.viewModel.state.foodValue))
                Haptic.impact(.medium).generate()
            })
            .disposed(by: disposeBag)
    }

    private func bindSuggestedContent(input: InputMealViewModelInput, output: InputMealViewModelOutput) {
        viewModel = LabelCanvasViewModel()
        suggestionDataSource = SuggestionDataSource(viewModel: viewModel)
        output.inputKeyword
            .bind(to: viewModel.input.inputKeyword)
            .disposed(by: disposeBag)

        viewModel.output.suggestionDidSelect
            .bind(to: input.suggestionDidSelect)
            .disposed(by: disposeBag)

        viewModel.output.suggestedContentResults
            .map { _ in }
            .bind(to: reloadData)
            .disposed(by: disposeBag)
    }

    private var reloadData: Binder<Void> {
        Binder<Void>(self) { me, _ in
            me.suggestionCollectionView.reloadData()
        }
    }

    private func configure(with image: UIImage?) {
        mealImageView.image = image
    }
}
