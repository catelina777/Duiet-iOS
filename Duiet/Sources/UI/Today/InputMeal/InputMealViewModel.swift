//
//  InputMealViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/05/03.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import RealmSwift

class InputMealViewModel {

    let mealImage: UIImage?
    let meal: Meal

    let input: Input
    let output: Output

    private let disposeBag = DisposeBag()

    init(mealImage: UIImage?,
         meal: Meal,
         model: MealModel) {

        self.mealImage = mealImage
        self.meal = meal

        let _addMealLabel = PublishRelay<MealLabelView>()
        let _selectedMealLabel = PublishRelay<MealLabelView?>()
        let _deleteMealLabel = PublishRelay<Void>()
        let _saveContent = PublishRelay<Content>()
        let _nameTextInput = PublishRelay<String?>()
        let _calorieTextInput = PublishRelay<String?>()
        let _multipleTextInput = PublishRelay<String?>()

        input = Input(addMealLabel: _addMealLabel.asObserver(),
                      selectedMealLabel: _selectedMealLabel.asObserver(),
                      deleteMealLabel: _deleteMealLabel.asObserver(),
                      saveContent: _saveContent.asObserver(),
                      nameTextInput: _nameTextInput.asObserver(),
                      calorieTextInput: _calorieTextInput.asObserver(),
                      multipleTextInput: _multipleTextInput.asObserver())

        let showLabelViews = Observable.of(meal.contents)
            .take(1)

        let selectedMealLabel = _selectedMealLabel.compactMap { $0 }

        let reloadData = _addMealLabel
            .map { _ in }

        output = Output(showLabelViews: showLabelViews.asObservable(),
                        selectedMealLabel: selectedMealLabel,
                        reloadData: reloadData)

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

        // MARK: - Reflect numbers on label
        Observable.combineLatest(selectedMealLabel, calorie, multiple)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                $0.0.mealLabel.text = "\(Int($0.1 * ($0.2 == 0 ? 1 : $0.2)))"
            })
            .disposed(by: disposeBag)

        // MARK: - Processing to save data
        _saveContent
            .map { (meal, $0) }
            .bind(to: model.rx.addContent)
            .disposed(by: disposeBag)

        name.withLatestFrom(selectedMealLabel) { ($1, $0) }
            .bind(to: model.rx.saveName)
            .disposed(by: disposeBag)

        calorie.withLatestFrom(selectedMealLabel) { ($1, $0) }
            .bind(to: model.rx.saveCalorie)
            .disposed(by: disposeBag)

        multiple.withLatestFrom(selectedMealLabel) { ($1, $0) }
            .bind(to: model.rx.saveMultiple)
            .disposed(by: disposeBag)

        // MARK: - Processing to delete content
        let _meal = Observable.just(meal)
        let _targetContent = selectedMealLabel.flatMap { $0.content }
        let prepareDelete = Observable.combineLatest(_meal, _targetContent)
        _deleteMealLabel.withLatestFrom(prepareDelete)
            .map { $0 }
            .bind(to: model.rx.deleteContent)
            .disposed(by: disposeBag)

        // MARK: - Send nil to the currently selected label so that it does not refer to the deleted object when the content deletion is completed
        model.contentDidDelete.withLatestFrom(selectedMealLabel)
            .subscribe(onNext: {
                $0.isHidden = true
                _selectedMealLabel.accept(nil)
            })
            .disposed(by: disposeBag)
    }
}

extension InputMealViewModel {

    struct Input {
        let addMealLabel: AnyObserver<MealLabelView>
        let selectedMealLabel: AnyObserver<MealLabelView?>
        let deleteMealLabel: AnyObserver<Void>
        let saveContent: AnyObserver<Content>
        let nameTextInput: AnyObserver<String?>
        let calorieTextInput: AnyObserver<String?>
        let multipleTextInput: AnyObserver<String?>
    }

    struct Output {
        let showLabelViews: Observable<List<Content>>
        let selectedMealLabel: Observable<MealLabelView>
        let reloadData: Observable<Void>
    }
}
