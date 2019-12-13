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
import ToolKits
import UIKit

final class LabelCanvasViewCell: BaseTableViewCell {
    @IBOutlet private weak var mealImageView: UIImageView!
    @IBOutlet private(set) weak var suggestionCollectionView: UICollectionView!

    private(set) var viewModel: LabelCanvasViewModelProtocol!
    private(set) var suggestionDataSource: SuggestionDataSource!

    // TODO: This code is terrible and should be refactored
    func configure(input: InputMealViewModelInput, output: InputMealViewModelOutput, state: InputMealViewModelState) {
        if !state.isShowedFoods.value {
            show(foods: state.foods, input: input)
            state.isShowedFoods.accept(true)
        }
        bindSuggestedFood(input: input, output: output)
        suggestionDataSource.configure(with: suggestionCollectionView)
        bindAddFood(input: input, state: state)
        configure(with: state.foodImage)
    }

    private func show(foods: [FoodEntity], input: InputMealViewModelInput) {
        foods.map { MealLabelView.build(foodEntity: $0) }.forEach { label in
            let food = label.viewModel.state.foodEntityValue
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

    /// Monitor screen presses and add food
    /// - Parameter input: ViewModel input
    private func bindAddFood(input: InputMealViewModelInput, state: InputMealViewModelState) {
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
                let food = Food(relativeX: relativeX,
                                relativeY: relativeY,
                                mealEntity: state.mealEntityValue)
                mealLabel.initialize(foodEntity: food.build())
                mealLabel.frame = labelFrame
                mealLabel.configure(input: input)
                return mealLabel
            }
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] mealLabel in
                guard let me = self else { return }
                me.addSubview(mealLabel)
                input.selectedLabelViewModel.on(.next(mealLabel.viewModel))
                input.foodWillAdd.on(.next(mealLabel.viewModel.state.foodEntityValue))
                Haptic.impact(.medium).generate()
            })
            .disposed(by: disposeBag)
    }

    private func bindSuggestedFood(input: InputMealViewModelInput, output: InputMealViewModelOutput) {
        viewModel = LabelCanvasViewModel()
        suggestionDataSource = SuggestionDataSource(viewModel: viewModel)
        output.inputKeyword
            .bind(to: viewModel.input.inputKeyword)
            .disposed(by: disposeBag)

        viewModel.output.suggestionDidSelect
            .bind(to: input.suggestionDidSelect)
            .disposed(by: disposeBag)

        viewModel.output.suggestedFoodResults
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
