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

    var contentCount: Int {
        return inputMealModel.meal.value.contents.count
    }

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
        let _selectedViewModel = PublishRelay<MealLabelViewModel>()
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

        let selectedContent = _selectedViewModel.map { $0.content }
        let updateTextFields = selectedContent
        let reloadData = model.contentDidAdd

        output = Output(showLabelsOnce: showLabelsOnce,
                        contentDidUpdate: model.contentDidUpdate.asObservable(),
                        updateTextFields: updateTextFields.asObservable(),
                        hideMealLabel: model.contentDidDelete.asObservable(),
                        reloadData: reloadData.asObservable())

        // MARK: - Update value when select a label
        selectedContent
            .subscribe(onNext: {
                _calorieTextInput.accept("\($0.calorie)")
                _multipleTextInput.accept("\($0.multiple)")
                _nameTextInput.accept($0.name)
            })
            .disposed(by: disposeBag)
        // END

        // MARK: - Save content
        _contentWillAdd.withLatestFrom(model.meal) { ($1, $0) }
            .bind(to: model.addContent)
            .disposed(by: disposeBag)
        // END

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
        // END

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
        // END

        // MARK: - Transition
        _dismiss
            .subscribe(onNext: { [weak self] in
                guard let me = self else { return }
                me.coordinator.dismiss()
            })
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
        let selectedViewModel: AnyObserver<MealLabelViewModel>
        let contentWillAdd: AnyObserver<Content>
        let contentWillDelete: AnyObserver<Void>
        let dismiss: AnyObserver<Void>
    }
    struct Output {
        let showLabelsOnce: Observable<[Content]>
        let contentDidUpdate: Observable<Content>
        let updateTextFields: Observable<Content>
        let hideMealLabel: Observable<Void>
        let reloadData: Observable<Void>
    }
}
