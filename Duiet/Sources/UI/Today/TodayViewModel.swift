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
import RxRealm

final class TodayViewModel {

    let title = "Today"

    let input: Input
    let output: Output

    var meals: [Meal] {
        return model.mealsValue
    }

    private let model: TodayModel
    private let disposeBag = DisposeBag()

    init() {
        self.model = TodayModel()

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

        // MARK: - Screen transition can't be made without viewDidAppear or later
        let canShowDetail = _viewDidAppear
            .map { true }
            .withLatestFrom(pickedImage)

        let meal = PublishRelay<Meal>()

        let showDetail = Observable.combineLatest(canShowDetail, meal)
            .take(1)

        output = Output(showDetail: showDetail)

        pickedImage
            .compactMap { $0 }
            .flatMapLatest { PhotoManager.rx.save(image: $0).take(1) }
            .map { Meal(imagePath: $0) }
            .bind(to: meal)
            .disposed(by: disposeBag)

        showDetail
            .map { $1 }
            .bind(to: Realm.rx.add())
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
