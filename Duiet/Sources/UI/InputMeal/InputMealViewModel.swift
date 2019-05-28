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

    let input: Input
    let output: Output

    var mealLabelViews: [MealLabelView] {
        return _mealLabelViews.value
    }

    private let _mealLabelViews = BehaviorRelay<[MealLabelView]>(value: [])
    private let disposeBag = DisposeBag()

    init(mealImage: UIImage?,
         meal: Meal,
         model: MealModel) {

        self.mealImage = mealImage

        let _addMealLabel = PublishRelay<MealLabelView?>()
        let _selectedMealLabel = PublishRelay<MealLabelView>()
        let _selectedContent = PublishRelay<Content>()
        let _saveContent = PublishRelay<Content>()
        let _name = PublishRelay<String>()
        let _calorie = PublishRelay<Double>()
        let _multiple = PublishRelay<Double>()

        input = Input(addMealLabel: _addMealLabel.asObserver(),
                      selectedMealLabel: _selectedMealLabel.asObserver(),
                      selectedContent: _selectedContent.asObserver(),
                      saveContent: _saveContent.asObserver(),
                      name: _name.asObserver(),
                      calorie: _calorie.asObserver(),
                      multiple: _multiple.asObserver())

        let reloadData = _addMealLabel
            .map { _ in }

        output = Output(mealLabelViews: _mealLabelViews.asObservable(),
                        reloadData: reloadData)

        Observable.combineLatest(_selectedMealLabel, _calorie, _multiple)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                $0.0.mealLabel.text = "\(Int($0.1 * ($0.2 == 0 ? 1 : $0.2)))"
            })
            .disposed(by: disposeBag)

        _saveContent
            .map { (meal, $0) }
            .bind(to: model.rx.addContent)
            .disposed(by: disposeBag)

        Observable.combineLatest(_selectedContent, _name)
            .bind(to: model.rx.saveName)
            .disposed(by: disposeBag)

        Observable.combineLatest(_selectedContent, _calorie)
            .bind(to: model.rx.saveCalorie)
            .disposed(by: disposeBag)

        Observable.combineLatest(_selectedContent, _multiple)
            .bind(to: model.rx.saveMultiple)
            .disposed(by: disposeBag)

        _addMealLabel
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] mealLabelView in
                guard let self = self else { return }
                var mealLabelViews = self._mealLabelViews.value
                mealLabelViews.append(mealLabelView)
                self._mealLabelViews.accept(mealLabelViews)
            })
            .disposed(by: disposeBag)
    }
}

extension InputMealViewModel {

    struct Input {
        let addMealLabel: AnyObserver<MealLabelView?>
        let selectedMealLabel: AnyObserver<MealLabelView>
        let selectedContent: AnyObserver<Content>
        let saveContent: AnyObserver<Content>
        let name: AnyObserver<String>
        let calorie: AnyObserver<Double>
        let multiple: AnyObserver<Double>
    }

    struct Output {
        let mealLabelViews: Observable<[MealLabelView]>
        let reloadData: Observable<Void>
    }
}
