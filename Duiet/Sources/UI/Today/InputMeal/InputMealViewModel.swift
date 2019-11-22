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
    var contentWillUpdate: AnyObserver<FoodEntity> { get }
    var contentWillAdd: AnyObserver<FoodEntity> { get }
    var contentWillDelete: AnyObserver<Void> { get }
    var dismiss: AnyObserver<Void> { get }
}

protocol InputMealViewModelOutput {
    var contentDidUpdate: Observable<FoodEntity> { get }
    var contentDidDelete: Observable<Void> { get }
    var updateTextFields: Observable<FoodEntity> { get }
    var reloadData: Observable<Void> { get }
    var inputKeyword: Observable<String> { get }
    var suggestionDidSelect: Observable<FoodEntity> { get }
}

protocol InputMealViewModelState {
    var isShowedContents: BehaviorRelay<Bool> { get }
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

    let isShowedContents = BehaviorRelay<Bool>(value: false)

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
        let contentWillAdd = PublishRelay<FoodEntity>()
        let contentWillUpdate = PublishRelay<FoodEntity>()
        let contentWillDelete = PublishRelay<Void>()
        let dismiss = PublishRelay<Void>()
        let suggestionDidSelect = PublishRelay<FoodEntity>()

        input = Input(nameTextInput: nameTextInput.asObserver(),
                      calorieTextInput: calorieTextInput.asObserver(),
                      multipleTextInput: multipleTextInput.asObserver(),
                      selectedLabelViewModel: selectedLabelViewModel.asObserver(),
                      contentWillAdd: contentWillAdd.asObserver(),
                      contentWillUpdate: contentWillUpdate.asObserver(),
                      contentWillDelete: contentWillDelete.asObserver(),
                      dismiss: dismiss.asObserver(),
                      suggestionDidSelect: suggestionDidSelect.asObserver())

        let selectedContent = selectedLabelViewModel.map { $0.state.foodEntityValue }

        let updateTextFields = selectedContent.compactMap { $0 }
        let reloadData = inputMealModel.output.contentDidAdd

        let name = nameTextInput
            .distinctUntilChanged()
            .map { $0 ?? "" }

        output = Output(contentDidUpdate: inputMealModel.output.contentDidUpdate.asObservable(),
                        contentDidDelete: inputMealModel.output.contentDidDelete.asObservable(),
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
        contentWillAdd.withLatestFrom(inputMealModel.output.meal) { ($0, $1) }
            .map { $0.meal = $1; return $0 }
            .bind(to: inputMealModel.state.add)
            .disposed(by: disposeBag)

        calorie.withLatestFrom(selectedContent) { ($0, $1) }
            .map { $1.calorie = $0; return $1 }
            .bind(to: inputMealModel.state.update)
            .disposed(by: disposeBag)

        multiple.withLatestFrom(selectedContent) { ($0, $1) }
            .map { $1.multiple = $0; return $1 }
            .bind(to: inputMealModel.state.update)
            .disposed(by: disposeBag)

        name.withLatestFrom(selectedContent) { ($0, $1) }
            .map { $1.name = $0; return $1 }
            .bind(to: inputMealModel.state.update)
            .disposed(by: disposeBag)

        contentWillUpdate.withLatestFrom(selectedContent) { ($0, $1) }
            .map { from, to in
                from.name = to.name
                from.calorie = to.calorie
                from.multiple = to.multiple
                from.updatedAt = Date()
                return from
            }
            .bind(to: inputMealModel.state.update)
            .disposed(by: disposeBag)

        // MARK: - Label processing
        // Notify label of a change in value
        inputMealModel.output.contentDidUpdate.withLatestFrom(selectedLabelViewModel) { ($0, $1) }
            .subscribe(onNext: {
                $0.1.input.contentDidUpdate.on(.next($0.0))
            })
            .disposed(by: disposeBag)

        // Delete content
        contentWillDelete.withLatestFrom(selectedContent)
            .bind(to: inputMealModel.state.delete)
            .disposed(by: disposeBag)

        // Notify label of content deleted
        inputMealModel.output.contentDidDelete.withLatestFrom(selectedLabelViewModel)
            .subscribe(onNext: {
                $0.input.contentDidDelete.on(.next(()))
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
        let contentWillAdd: AnyObserver<FoodEntity>
        let contentWillUpdate: AnyObserver<FoodEntity>
        let contentWillDelete: AnyObserver<Void>
        let dismiss: AnyObserver<Void>
        let suggestionDidSelect: AnyObserver<FoodEntity>
    }
    struct Output: InputMealViewModelOutput {
        let contentDidUpdate: Observable<FoodEntity>
        let contentDidDelete: Observable<Void>
        let updateTextFields: Observable<FoodEntity>
        let reloadData: Observable<Void>
        let inputKeyword: Observable<String>
        let suggestionDidSelect: Observable<FoodEntity>
    }
}
