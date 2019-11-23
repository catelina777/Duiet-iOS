//
//  InputMealViewModel.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/07/11.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift
import UIKit.UIImage

protocol InputMealViewModelInput {
    var nameTextInput: AnyObserver<String?> { get }
    var calorieTextInput: AnyObserver<String?> { get }
    var multipleTextInput: AnyObserver<String?> { get }
    var selectedLabelViewModel: AnyObserver<MealLabelViewModelProtocol> { get }
    var suggestionDidSelect: AnyObserver<FoodEntity> { get }
    var foodWillUpdate: AnyObserver<FoodEntity> { get }
    var foodWillAdd: AnyObserver<FoodEntity> { get }
    var foodWillDelete: AnyObserver<Void> { get }
    var dismiss: AnyObserver<Void> { get }
}

protocol InputMealViewModelOutput {
    var foodDidUpdate: Observable<FoodEntity> { get }
    var foodDidDelete: Observable<Void> { get }
    var updateTextFields: Observable<FoodEntity> { get }
    var reloadData: Observable<Void> { get }
    var inputKeyword: Observable<String> { get }
    var suggestionDidSelect: Observable<FoodEntity> { get }
}

protocol InputMealViewModelState {
    var isShowedFoods: BehaviorRelay<Bool> { get }
    var foods: [FoodEntity] { get }
    var foodImage: UIImage? { get }
    var mealEntityValue: MealEntity { get }
}

protocol InputMealViewModelProtocol {
    var input: InputMealViewModelInput { get }
    var output: InputMealViewModelOutput { get }
    var state: InputMealViewModelState { get }
}

final class InputMealViewModel: InputMealViewModelProtocol, InputMealViewModelState {
    let input: InputMealViewModelInput
    let output: InputMealViewModelOutput
    var state: InputMealViewModelState { self }

    // MARK: - State
    var foods: [FoodEntity] {
        Array(inputMealModel.state.mealEntityValue.foods ?? [])
    }

    let foodImage: UIImage?

    let isShowedFoods = BehaviorRelay<Bool>(value: false)

    var mealEntityValue: MealEntity {
        inputMealModel.state.mealEntityValue
    }

    private let inputMealModel: InputMealModelProtocol
    private let disposeBag = DisposeBag()

    init(coordinator: TodayCoordinator,
         inputMealModel: InputMealModelProtocol,
         foodImage: UIImage?) {
        self.inputMealModel = inputMealModel
        self.foodImage = foodImage

        let nameTextInput = PublishRelay<String?>()
        let calorieTextInput = PublishRelay<String?>()
        let multipleTextInput = PublishRelay<String?>()
        let selectedLabelViewModel = PublishRelay<MealLabelViewModelProtocol>()
        let foodWillAdd = PublishRelay<FoodEntity>()
        let foodWillUpdate = PublishRelay<FoodEntity>()
        let foodWillDelete = PublishRelay<Void>()
        let dismiss = PublishRelay<Void>()
        let suggestionDidSelect = PublishRelay<FoodEntity>()

        input = Input(nameTextInput: nameTextInput.asObserver(),
                      calorieTextInput: calorieTextInput.asObserver(),
                      multipleTextInput: multipleTextInput.asObserver(),
                      selectedLabelViewModel: selectedLabelViewModel.asObserver(),
                      foodWillAdd: foodWillAdd.asObserver(),
                      foodWillUpdate: foodWillUpdate.asObserver(),
                      foodWillDelete: foodWillDelete.asObserver(),
                      dismiss: dismiss.asObserver(),
                      suggestionDidSelect: suggestionDidSelect.asObserver())

        let selectedFood = selectedLabelViewModel.map { $0.state.foodEntityValue }

        let updateTextFields = selectedFood.compactMap { $0 }
        let reloadData = inputMealModel.output.foodDidAdd

        let name = nameTextInput
            .distinctUntilChanged()
            .map { $0 ?? "" }

        output = Output(foodDidUpdate: inputMealModel.output.foodDidUpdate.asObservable(),
                        foodDidDelete: inputMealModel.output.foodDidDelete.asObservable(),
                        updateTextFields: updateTextFields.asObservable(),
                        reloadData: reloadData.asObservable(),
                        inputKeyword: name,
                        suggestionDidSelect: suggestionDidSelect.asObservable())

        // MARK: - Process of manipulate input from textfield
        let calorie = calorieTextInput
            .compactMap { $0 }
            .map { Double($0) ?? 0 }
            .map { UnitBabel.shared.convert(value: $0, from: UnitCollectionModel.shared.unitCollectionValue.energyUnit, to: .kilocalories) }
            .distinctUntilChanged()
            .share()

        let multiple = multipleTextInput
            .compactMap { $0 }
            .map { Double($0) ?? 1 }
            .distinctUntilChanged()
            .share()

        // MARK: - Save processing
        foodWillAdd.withLatestFrom(inputMealModel.output.meal) { ($0, $1) }
            .map { $0.meal = $1; return $0 }
            .bind(to: inputMealModel.state.add)
            .disposed(by: disposeBag)

        calorie.withLatestFrom(selectedFood) { ($0, $1) }
            .map { $1.calorie = $0; return $1 }
            .bind(to: inputMealModel.state.update)
            .disposed(by: disposeBag)

        multiple.withLatestFrom(selectedFood) { ($0, $1) }
            .map { $1.multiple = $0; return $1 }
            .bind(to: inputMealModel.state.update)
            .disposed(by: disposeBag)

        name.withLatestFrom(selectedFood) { ($0, $1) }
            .map { $1.name = $0; return $1 }
            .bind(to: inputMealModel.state.update)
            .disposed(by: disposeBag)

        foodWillUpdate.withLatestFrom(selectedFood) { ($1, $0) }
            .map { from, to in
                from.name = to.name
                from.calorie = to.calorie
                from.multiple = to.multiple
                from.updatedAt = Date()
                return from
            }
            .bind(to: inputMealModel.state.update)
            .disposed(by: disposeBag)

        inputMealModel.output.foodDidUpdate.withLatestFrom(selectedLabelViewModel) { ($0, $1) }
            .subscribe(onNext: {
                $0.1.input.foodDidUpdate.on(.next($0.0))
            })
            .disposed(by: disposeBag)

        foodWillDelete.withLatestFrom(selectedFood)
            .bind(to: inputMealModel.state.delete)
            .disposed(by: disposeBag)

        inputMealModel.output.foodDidDelete.withLatestFrom(selectedLabelViewModel)
            .subscribe(onNext: {
                $0.input.foodDidDelete.on(.next(()))
            })
            .disposed(by: disposeBag)

        // MARK: - Transition
        dismiss
            .subscribe(onNext: {
                coordinator.dismiss()
            })
            .disposed(by: disposeBag)
    }
}

extension InputMealViewModel {
    struct Input: InputMealViewModelInput {
        let nameTextInput: AnyObserver<String?>
        let calorieTextInput: AnyObserver<String?>
        let multipleTextInput: AnyObserver<String?>
        let selectedLabelViewModel: AnyObserver<MealLabelViewModelProtocol>
        let foodWillAdd: AnyObserver<FoodEntity>
        let foodWillUpdate: AnyObserver<FoodEntity>
        let foodWillDelete: AnyObserver<Void>
        let dismiss: AnyObserver<Void>
        let suggestionDidSelect: AnyObserver<FoodEntity>
    }
    struct Output: InputMealViewModelOutput {
        let foodDidUpdate: Observable<FoodEntity>
        let foodDidDelete: Observable<Void>
        let updateTextFields: Observable<FoodEntity>
        let reloadData: Observable<Void>
        let inputKeyword: Observable<String>
        let suggestionDidSelect: Observable<FoodEntity>
    }
}
