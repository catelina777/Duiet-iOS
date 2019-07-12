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
        let _selectedContent = PublishRelay<Content>()
        let _contentDidAdd = PublishRelay<Void>()
        let _contentWillDelete = PublishRelay<Void>()

        input = Input(nameTextInput: _nameTextInput.asObserver(),
                      calorieTextInput: _calorieTextInput.asObserver(),
                      multipleTextInput: _multipleTextInput.asObserver(),
                      selectedContent: _selectedContent.asObserver(),
                      contentDidAdd: _contentDidAdd.asObserver(),
                      contentWillDelete: _contentWillDelete.asObserver())

        let showLabelsOnce = model.meal
            .compactMap { $0 }
            .map { $0.contents.toArray() }
            .take(1)

        let updateTextFields = _selectedContent
        let reloadData = _contentDidAdd

        output = Output(showLabelsOnce: showLabelsOnce,
                        contentDidUpdate: model.contentDidUpdate.asObservable(),
                        updateTextFields: updateTextFields.asObservable(),
                        hideMealLabel: model.contentDidDelete.asObservable(),
                        reloadData: reloadData.asObservable())

        // MARK: - Update value when select a label
        _selectedContent
            .subscribe(onNext: {
                _calorieTextInput.accept("\($0.calorie)")
                _multipleTextInput.accept("\($0.multiple)")
                _nameTextInput.accept($0.name)
            })
            .disposed(by: disposeBag)

        // MARK: - Update value by text input
        let calorie = _calorieTextInput
            .compactMap { $0 }
            .map { Double($0) ?? 0 }
            .distinctUntilChanged()
            .share()

        calorie.withLatestFrom(_selectedContent) { ($1, $0) }
            .bind(to: model.saveCalorie)
            .disposed(by: disposeBag)

        let multiple = _multipleTextInput
            .compactMap { $0 }
            .map { Double($0) ?? 0 }
            .distinctUntilChanged()
            .share()

        multiple.withLatestFrom(_selectedContent) { ($1, $0) }
            .bind(to: model.saveMultiple)
            .disposed(by: disposeBag)

        let name = _nameTextInput
            .distinctUntilChanged()
            .map { $0 ?? "" }

        name.withLatestFrom(_selectedContent) { ($1, $0) }
            .bind(to: model.saveName)
            .disposed(by: disposeBag)

        // MARK: - Delete content
        let meal = model.meal.compactMap { $0 }
        let deleteTarget = Observable.combineLatest(meal, _selectedContent)
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
        let selectedContent: AnyObserver<Content>
        let contentDidAdd: AnyObserver<Void>
        let contentWillDelete: AnyObserver<Void>
    }
    struct Output {
        let showLabelsOnce: Observable<[Content]>
        let contentDidUpdate: Observable<Content>
        let updateTextFields: Observable<Content>
        let hideMealLabel: Observable<Void>
        let reloadData: Observable<Void>
    }
}
