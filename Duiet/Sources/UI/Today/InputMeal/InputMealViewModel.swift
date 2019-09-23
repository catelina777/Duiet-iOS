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
    var selectedViewModel: AnyObserver<MealLabelViewModelProtocol> { get }
    var contentWillAdd: AnyObserver<Content> { get }
    var contentWillDelete: AnyObserver<Void> { get }
    var dismiss: AnyObserver<Void> { get }
}

protocol InputMealViewModelOutput {
    var showLabelsOnce: Observable<[Content]> { get }
    var contentDidUpdate: Observable<Content> { get }
    var contentDidDelete: Observable<Void> { get }
    var updateTextFields: Observable<Content> { get }
    var reloadData: Observable<Void> { get }
}

protocol InputMealViewModelData {
    var contentCount: Int { get }
    var foodImage: UIImage? { get }
}

protocol InputMealViewModelProtocol {
    var input: InputMealViewModelInput { get }
    var output: InputMealViewModelOutput { get }
    var data: InputMealViewModelData { get }
}

final class InputMealViewModel: InputMealViewModelProtocol, InputMealViewModelData {
    let input: InputMealViewModelInput
    let output: InputMealViewModelOutput
    var data: InputMealViewModelData { return self }

    let foodImage: UIImage?
    private let inputMealModel: InputMealModelProtocol
    private let disposeBag = DisposeBag()

    init(coordinator: TodayCoordinator,
         model: InputMealModelProtocol,
         foodImage: UIImage?) {
        inputMealModel = model
        self.foodImage = foodImage

        let _nameTextInput = PublishRelay<String?>()
        let _calorieTextInput = PublishRelay<String?>()
        let _multipleTextInput = PublishRelay<String?>()
        let _selectedViewModel = PublishRelay<MealLabelViewModelProtocol>()
        let _contentWillAdd = PublishRelay<Content>()
        let _contentWillDelete = PublishRelay<Void>()
        let _dismiss = PublishRelay<Void>()

        input = Input(nameTextInput: _nameTextInput.asObserver(),
                      calorieTextInput: _calorieTextInput.asObserver(),
                      multipleTextInput: _multipleTextInput.asObserver(),
                      selectedViewModel: _selectedViewModel.asObserver(),
                      contentWillAdd: _contentWillAdd.asObserver(),
                      contentWillDelete: _contentWillDelete.asObserver(),
                      dismiss: _dismiss.asObserver())

        let showLabelsOnce = model.meal
            .map { $0.contents.toArray() }
            .take(1)

        let selectedContent = _selectedViewModel.map { $0.data.content }

        let updateTextFields = selectedContent.compactMap { $0 }
        let reloadData = model.contentDidAdd

        output = Output(showLabelsOnce: showLabelsOnce,
                        contentDidUpdate: model.contentDidUpdate.asObservable(),
                        contentDidDelete: model.contentDidDelete.asObservable(),
                        updateTextFields: updateTextFields.asObservable(),
                        reloadData: reloadData.asObservable())

        // MARK: - Save content
        _contentWillAdd.withLatestFrom(model.meal) { ($1, $0) }
            .bind(to: model.addContent)
            .disposed(by: disposeBag)

        // MARK: - Save value by text input
        let calorie = _calorieTextInput
            .compactMap { $0 }
            .map { Double($0) ?? 0 }
            .distinctUntilChanged()
            .share()

        let multiple = _multipleTextInput
            .compactMap { $0 }
            .map { Double($0) ?? 0 }
            .distinctUntilChanged()
            .share()

        let name = _nameTextInput
            .distinctUntilChanged()
            .map { $0 ?? "" }

        calorie.withLatestFrom(selectedContent) { ($1, $0) }
            .bind(to: model.saveCalorie)
            .disposed(by: disposeBag)

        multiple.withLatestFrom(selectedContent) { ($1, $0) }
            .bind(to: model.saveMultiple)
            .disposed(by: disposeBag)

        name.withLatestFrom(selectedContent) { ($1, $0) }
            .bind(to: model.saveName)
            .disposed(by: disposeBag)

        // MARK: - Notify label of a change in value
        model.contentDidUpdate.withLatestFrom(_selectedViewModel) { ($0, $1) }
            .subscribe(onNext: {
                $0.1.input.contentDidUpdate.on(.next($0.0))
            })
            .disposed(by: disposeBag)

        // MARK: - Delete content
        let deleteTarget = Observable.combineLatest(model.meal, selectedContent)
        _contentWillDelete.withLatestFrom(deleteTarget)
            .bind(to: model.deleteContent)
            .disposed(by: disposeBag)

        // MARK: - Notify label of content deleted
        model.contentDidDelete.withLatestFrom(_selectedViewModel)
            .subscribe(onNext: {
                $0.input.contentDidDelete.on(.next(()))
            })
            .disposed(by: disposeBag)

        // MARK: - Transition
        _dismiss
            .subscribe(onNext: {
                coordinator.dismiss()
            })
            .disposed(by: disposeBag)
    }

    deinit {
        print("🧹🧹🧹 InputMealViewModel parge 🧹🧹🧹")
    }
}

extension InputMealViewModel {
    struct Input: InputMealViewModelInput {
        let nameTextInput: AnyObserver<String?>
        let calorieTextInput: AnyObserver<String?>
        let multipleTextInput: AnyObserver<String?>
        let selectedViewModel: AnyObserver<MealLabelViewModelProtocol>
        let contentWillAdd: AnyObserver<Content>
        let contentWillDelete: AnyObserver<Void>
        let dismiss: AnyObserver<Void>
    }
    struct Output: InputMealViewModelOutput {
        let showLabelsOnce: Observable<[Content]>
        let contentDidUpdate: Observable<Content>
        let contentDidDelete: Observable<Void>
        let updateTextFields: Observable<Content>
        let reloadData: Observable<Void>
    }

    var contentCount: Int {
        inputMealModel.meal.value.contents.count
    }
}
