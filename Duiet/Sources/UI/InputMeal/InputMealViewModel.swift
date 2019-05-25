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

class InputMealViewModel {

    let mealImage: UIImage?

    let input: Input
    let output: Output

    private let _mealLabelViews = BehaviorRelay<[MealLabelView]>(value: [])
    private let disposeBag = DisposeBag()

    init(mealImage: UIImage?,
         meal: Meal) {

        self.mealImage = mealImage

        let _addMealLabel = PublishRelay<MealLabelView?>()
        let _selectedContent = PublishRelay<Content>()
        let _saveContent = PublishRelay<Content>()
        let _name = PublishRelay<String>()
        let _calorie = PublishRelay<Double>()
        let _multiple = PublishRelay<Double>()

        input = Input(addMealLabel: _addMealLabel.asObserver(),
                      selectedContent: _selectedContent.asObserver(),
                      saveContent: _saveContent.asObserver(),
                      name: _name.asObserver(),
                      calorie: _calorie.asObserver(),
                      multiple: _multiple.asObserver())

        output = Output(mealLabelViews: _mealLabelViews.asObservable())

        _saveContent
            .map { $0 }
            .subscribe(onNext: { content in
                meal.rx.addContent.on(.next(content))
            })
            .disposed(by: disposeBag)

        Observable.combineLatest(_selectedContent, _name)
            .subscribe(onNext: { content, name in
                content.rx.saveName.on(.next(name))
            })
            .disposed(by: disposeBag)

        Observable.combineLatest(_selectedContent, _calorie)
            .subscribe(onNext: { content, calorie in
                content.rx.saveCalorie.on(.next(calorie))
            })
            .disposed(by: disposeBag)

        Observable.combineLatest(_selectedContent, _multiple)
            .subscribe(onNext: { content, multiple in
                content.rx.saveMultiple.on(.next(multiple))
            })
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
        let selectedContent: AnyObserver<Content>
        let saveContent: AnyObserver<Content>
        let name: AnyObserver<String>
        let calorie: AnyObserver<Double>
        let multiple: AnyObserver<Double>
    }

    struct Output {
        let mealLabelViews: Observable<[MealLabelView]>
    }
}
