//
//  NewInputMealViewModel.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/07/11.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class NewInputMealViewModel {

    let input: Input
    let output: Output

    private let inputMealModel: InputMealModelProtocol
    private let coordinator: DayCoordinator
    private let disposeBag = DisposeBag()

    init(coordinator: DayCoordinator,
         model: InputMealModelProtocol) {
        self.coordinator = coordinator
        self.inputMealModel = model

        let _nameTextInput = PublishRelay<String?>()
        let _calorieTextInput = PublishRelay<String?>()
        let _multipleTextInput = PublishRelay<String?>()
        let _selectedMealLabelViewModel = PublishRelay<MealLabelViewModel>()
        let _contentDidAdd = PublishRelay<Void>()
        let _contentWillDelete = PublishRelay<Void>()

        input = Input(nameTextInput: _nameTextInput.asObserver(),
                      calorieTextInput: _calorieTextInput.asObserver(),
                      multipleTextInput: _multipleTextInput.asObserver(),
                      selectedMealLabelViewModel: _selectedMealLabelViewModel.asObserver(),
                      contentDidAdd: _contentDidAdd.asObserver(),
                      contentWillDelete: _contentWillDelete.asObserver())

        let reloadData = _contentDidAdd

        output = Output(updateLabelText: model.contentDidUpdate.asObservable(),
                        hideMealLabel: model.contentDidDelete.asObservable(),
                        reloadData: reloadData.asObservable())

        // MARK: - Update value by text input
        let calorie = _calorieTextInput
            .compactMap { $0 }
            .map { Double($0) ?? 0 }
            .distinctUntilChanged()
            .share()

        calorie.withLatestFrom(_selectedMealLabelViewModel) { ($1.content, $0) }
            .bind(to: model.saveCalorie)
            .disposed(by: disposeBag)

        let multiple = _multipleTextInput
            .compactMap { $0 }
            .map { Double($0) ?? 0 }
            .distinctUntilChanged()
            .share()

        multiple.withLatestFrom(_selectedMealLabelViewModel) { ($1.content, $0) }
            .bind(to: model.saveMultiple)
            .disposed(by: disposeBag)

        let name = _nameTextInput
            .distinctUntilChanged()
            .map { $0 ?? "" }

        name.withLatestFrom(_selectedMealLabelViewModel) { ($1.content, $0) }
            .bind(to: model.saveName)
            .disposed(by: disposeBag)

        // MARK: - Delete content
        let meal = model.meal.compactMap { $0 }
        let deleteTargetContent = _selectedMealLabelViewModel.map { $0.content }
        let deleteTarget = Observable.combineLatest(meal, deleteTargetContent)
        _contentWillDelete.withLatestFrom(deleteTarget)
            .bind(to: model.deleteContent)
            .disposed(by: disposeBag)
    }

    deinit {
        print("🧹🧹🧹 NewInputMealViewModel parge 🧹🧹🧹")
    }
}

extension NewInputMealViewModel {

    struct Input {
        let nameTextInput: AnyObserver<String?>
        let calorieTextInput: AnyObserver<String?>
        let multipleTextInput: AnyObserver<String?>
        let selectedMealLabelViewModel: AnyObserver<MealLabelViewModel>
        let contentDidAdd: AnyObserver<Void>
        let contentWillDelete: AnyObserver<Void>
    }
    struct Output {
        let updateLabelText: Observable<Content>
        let hideMealLabel: Observable<Void>
        let reloadData: Observable<Void>
    }
}
