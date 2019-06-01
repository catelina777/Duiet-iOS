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
        let _selectedMealLabel = PublishRelay<MealLabelView>()
        let _saveContent = PublishRelay<Content>()
        let _nameTextInput = PublishRelay<String?>()
        let _calorieTextInput = PublishRelay<String?>()
        let _multipleTextInput = PublishRelay<String?>()

        input = Input(addMealLabel: _addMealLabel.asObserver(),
                      selectedMealLabel: _selectedMealLabel.asObserver(),
                      saveContent: _saveContent.asObserver(),
                      nameTextInput: _nameTextInput.asObserver(),
                      calorieTextInput: _calorieTextInput.asObserver(),
                      multipleTextInput: _multipleTextInput.asObserver())

        let showLabelViews = Observable.of(meal.contents)
            .take(1)

        let reloadData = _addMealLabel
            .map { _ in }

        output = Output(showLabelViews: showLabelViews.asObservable(),
                        selectedMealLabel: _selectedMealLabel.asObservable(),
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

        Observable.combineLatest(_selectedMealLabel, calorie, multiple)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                $0.0.mealLabel.text = "\(Int($0.1 * ($0.2 == 0 ? 1 : $0.2)))"
            })
            .disposed(by: disposeBag)

        _saveContent
            .map { (meal, $0) }
            .bind(to: model.rx.addContent)
            .disposed(by: disposeBag)

        name.withLatestFrom(_selectedMealLabel) { ($1, $0) }
            .bind(to: model.rx.saveName)
            .disposed(by: disposeBag)

        calorie.withLatestFrom(_selectedMealLabel) { ($1, $0) }
            .bind(to: model.rx.saveCalorie)
            .disposed(by: disposeBag)

        multiple.withLatestFrom(_selectedMealLabel) { ($1, $0) }
            .bind(to: model.rx.saveMultiple)
            .disposed(by: disposeBag)
    }
}

extension InputMealViewModel {

    struct Input {
        let addMealLabel: AnyObserver<MealLabelView>
        let selectedMealLabel: AnyObserver<MealLabelView>
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
