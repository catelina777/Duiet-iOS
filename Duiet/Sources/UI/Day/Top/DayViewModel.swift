//
//  DayViewModel.swift
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

final class DayViewModel {

    let input: Input
    let output: Output

    let userInfoModel: UserInfoModel
    let mealModel: MealModel
    private let disposeBag = DisposeBag()

    var meals: [Meal] {
        return mealModel.meals.value
    }

    init() {
        self.userInfoModel = UserInfoModel.shared
        self.mealModel = MealModel.shared

        let _viewDidAppear = PublishRelay<Void>()
        let _viewDidDisappear = PublishRelay<Void>()
        let _addButtonTap = PublishRelay<DayViewController>()
        let _selectedItem = PublishRelay<(MealCardViewCell, Meal)>()

        input = Input(viewDidAppear: _viewDidAppear.asObserver(),
                      viewDidDisappear: _viewDidDisappear.asObserver(),
                      addButtonTap: _addButtonTap.asObserver(),
                      selectedItem: _selectedItem.asObserver())

        let pickedImage = _addButtonTap
            .flatMapLatest { vc in
                return RxYPImagePicker.rx
                    .create(vc)
                    .flatMap { $0.pickedImage }
                    .take(1)
            }
            .share()

        let meal = PublishRelay<Meal>()

        /// Screen transition can't be made without viewDidAppear or later
        let showDetail = Observable.combineLatest(pickedImage, meal)
            .withLatestFrom(_viewDidAppear) { ($0, $1) }
            .map { ($0.0.0, $0.0.1) }
            .share()

        let editDetail = _selectedItem

        /// I also added meals because I want to detect the update of meal information
        let progress = Observable.combineLatest(mealModel.day, userInfoModel.userInfo, mealModel.meals)
            .map { ($0.0, $0.1) }

        output = Output(showDetail: showDetail,
                        editDetail: editDetail.asObservable(),
                        changeData: mealModel.changeData.asObservable(),
                        progress: progress)

        pickedImage
            .compactMap { $0 }
            .flatMapLatest { PhotoManager.rx.save(image: $0) }
            .map { Meal(imagePath: $0) }
            .bind(to: meal)
            .disposed(by: disposeBag)

        meal
            .map { $0 }
            .bind(to: mealModel.rx.addMeal)
            .disposed(by: disposeBag)
    }
}

extension DayViewModel {

    struct Input {
        let viewDidAppear: AnyObserver<Void>
        let viewDidDisappear: AnyObserver<Void>
        let addButtonTap: AnyObserver<DayViewController>
        let selectedItem: AnyObserver<(MealCardViewCell, Meal)>
    }

    struct Output {
        let showDetail: Observable<(UIImage?, Meal)>
        let editDetail: Observable<(MealCardViewCell, Meal)>
        let changeData: Observable<RealmChangeset?>
        let progress: Observable<(Day, UserInfo)>
    }
}
