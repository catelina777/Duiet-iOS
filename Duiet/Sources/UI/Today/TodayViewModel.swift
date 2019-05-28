//
//  TodayViewModel.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/23.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RealmSwift

final class TodayViewModel {

    let title = "Today"

    let input: Input
    let output: Output

    var meals: [Meal] {
        return model.mealsValue
    }

    let model: MealModel
    private let disposeBag = DisposeBag()

    init() {
        self.model = MealModel()

        let _viewDidAppear = PublishRelay<Void>()
        let _viewDidDisappear = PublishRelay<Void>()
        let _addButtonTap = PublishRelay<TodayViewController>()

        input = Input(viewDidAppear: _viewDidAppear.asObserver(),
                      viewDidDisappear: _viewDidDisappear.asObserver(),
                      addButtonTap: _addButtonTap.asObserver())

        let pickedImage = _addButtonTap
            .flatMapLatest { vc in
                return RxYPImagePicker.rx
                    .create(vc)
                    .flatMap { $0.pickedImage }
                    .take(1)
            }
            .share()

        let meal = PublishRelay<Meal>()

        // MARK: - Screen transition can't be made without viewDidAppear or later
        let showDetail = Observable.combineLatest(pickedImage, meal)
            .withLatestFrom(_viewDidAppear) { ($0, $1) }
            .map { ($0.0.0, $0.0.1) }
            .share()

        output = Output(showDetail: showDetail)

        pickedImage
            .compactMap { $0 }
            .flatMapLatest { PhotoManager.rx.save(image: $0) }
            .map { Meal(imagePath: $0) }
            .bind(to: meal)
            .disposed(by: disposeBag)

        // MARK: - Doing here because the specification of Realm.rx.add is bad and I can't bind at one time
        meal
            .map { $0 }
            .bind(to: model.rx.addMeal)
            .disposed(by: disposeBag)
    }
}

extension TodayViewModel {

    struct Input {
        let viewDidAppear: AnyObserver<Void>
        let viewDidDisappear: AnyObserver<Void>
        let addButtonTap: AnyObserver<TodayViewController>
    }

    struct Output {
        let showDetail: Observable<(UIImage?, Meal)>
    }
}
