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
    var suggestionDidSelect: AnyObserver<Content> { get }
    var contentWillUpdate: AnyObserver<Content> { get }
    var contentWillAdd: AnyObserver<Content> { get }
    var contentWillDelete: AnyObserver<Void> { get }
    var dismiss: AnyObserver<Void> { get }
}

protocol InputMealViewModelOutput {
    var contentDidUpdate: Observable<Content> { get }
    var contentDidDelete: Observable<Void> { get }
    var updateTextFields: Observable<Content> { get }
    var reloadData: Observable<Void> { get }
    var inputKeyword: Observable<String> { get }
    var suggestionDidSelect: Observable<Content> { get }
}

protocol InputMealViewModelState {
    var isShowedContents: BehaviorRelay<Bool> { get }
    var contents: [Content] { get }
    var foodImage: UIImage? { get }
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
    var contents: [Content] {
        inputMealModel.state.mealValue.contents.toArray()
    }

    let foodImage: UIImage?

    let isShowedContents = BehaviorRelay<Bool>(value: false)

    private let inputMealModel: InputMealModelProtocol
    private let disposeBag = DisposeBag()

    init(coordinator: TodayCoordinator,
         model: InputMealModelProtocol,
         foodImage: UIImage?) {
        inputMealModel = model
        self.foodImage = foodImage

        let nameTextInput = PublishRelay<String?>()
        let calorieTextInput = PublishRelay<String?>()
        let multipleTextInput = PublishRelay<String?>()
        let selectedLabelViewModel = PublishRelay<MealLabelViewModelProtocol>()
        let contentWillAdd = PublishRelay<Content>()
        let contentWillUpdate = PublishRelay<Content>()
        let contentWillDelete = PublishRelay<Void>()
        let dismiss = PublishRelay<Void>()
        let suggestionDidSelect = PublishRelay<Content>()

        input = Input(nameTextInput: nameTextInput.asObserver(),
                      calorieTextInput: calorieTextInput.asObserver(),
                      multipleTextInput: multipleTextInput.asObserver(),
                      selectedLabelViewModel: selectedLabelViewModel.asObserver(),
                      contentWillAdd: contentWillAdd.asObserver(),
                      contentWillUpdate: contentWillUpdate.asObserver(),
                      contentWillDelete: contentWillDelete.asObserver(),
                      dismiss: dismiss.asObserver(),
                      suggestionDidSelect: suggestionDidSelect.asObserver())

        let selectedContent = selectedLabelViewModel.map { $0.state.contentValue }

        let updateTextFields = selectedContent.compactMap { $0 }
        let reloadData = model.output.contentDidAdd

        let name = nameTextInput
            .distinctUntilChanged()
            .map { $0 ?? "" }

        output = Output(contentDidUpdate: model.output.contentDidUpdate.asObservable(),
                        contentDidDelete: model.output.contentDidDelete.asObservable(),
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
            .map { Double($0) ?? 0 }
            .distinctUntilChanged()
            .share()

        // MARK: - Save processing
        contentWillAdd.withLatestFrom(model.output.meal) { ($1, $0) }
            .bind(to: model.state.addContent)
            .disposed(by: disposeBag)

        calorie.withLatestFrom(selectedContent) { ($1, $0) }
            .bind(to: model.state.saveCalorie)
            .disposed(by: disposeBag)

        multiple.withLatestFrom(selectedContent) { ($1, $0) }
            .bind(to: model.state.saveMultiple)
            .disposed(by: disposeBag)

        name.withLatestFrom(selectedContent) { ($1, $0) }
            .bind(to: model.state.saveName)
            .disposed(by: disposeBag)

        contentWillUpdate.withLatestFrom(selectedContent) { ($0, $1) }
            .bind(to: model.state.updateContent)
            .disposed(by: disposeBag)

        // MARK: - Label processing
        // Notify label of a change in value
        model.output.contentDidUpdate.withLatestFrom(selectedLabelViewModel) { ($0, $1) }
            .subscribe(onNext: {
                $0.1.input.contentDidUpdate.on(.next($0.0))
            })
            .disposed(by: disposeBag)

        // Delete content
        let deleteTarget = Observable.combineLatest(model.output.meal, selectedContent)
        contentWillDelete.withLatestFrom(deleteTarget)
            .bind(to: model.state.deleteContent)
            .disposed(by: disposeBag)

        // Notify label of content deleted
        model.output.contentDidDelete.withLatestFrom(selectedLabelViewModel)
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

    deinit {
        Logger.shared.info("🧹memory released🧹")
    }
}

extension InputMealViewModel {
    struct Input: InputMealViewModelInput {
        let nameTextInput: AnyObserver<String?>
        let calorieTextInput: AnyObserver<String?>
        let multipleTextInput: AnyObserver<String?>
        let selectedLabelViewModel: AnyObserver<MealLabelViewModelProtocol>
        let contentWillAdd: AnyObserver<Content>
        let contentWillUpdate: AnyObserver<Content>
        let contentWillDelete: AnyObserver<Void>
        let dismiss: AnyObserver<Void>
        let suggestionDidSelect: AnyObserver<Content>
    }
    struct Output: InputMealViewModelOutput {
        let contentDidUpdate: Observable<Content>
        let contentDidDelete: Observable<Void>
        let updateTextFields: Observable<Content>
        let reloadData: Observable<Void>
        let inputKeyword: Observable<String>
        let suggestionDidSelect: Observable<Content>
    }
}
