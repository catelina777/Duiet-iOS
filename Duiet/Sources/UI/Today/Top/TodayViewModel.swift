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

    let input: Input
    let output: Output

    let userInfoModel: UserInfoModelProtocol
    let todayModel: TodayModelProtocol

    private let disposeBag = DisposeBag()

    var meals: List<Meal> {
        return todayModel.day.value.meals
    }

    var title: String {
        return todayModel.title
    }

    init(coordinator: TodayCoordinator,
         userInfoModel: UserInfoModelProtocol,
         todayModel: TodayModelProtocol) {
        self.userInfoModel = userInfoModel
        self.todayModel = todayModel

        let _viewDidAppear = PublishRelay<Void>()
        let _addButtonTap = PublishRelay<TodayViewController>()
        let _selectedItem = PublishRelay<(MealCardViewCell, Meal)>()
        let _showDetailDay = PublishRelay<Day>()

        input = Input(viewDidAppear: _viewDidAppear.asObserver(),
                      addButtonTap: _addButtonTap.asObserver(),
                      selectedItem: _selectedItem.asObserver(),
                      showDetailDay: _showDetailDay.asObserver())

        let pickedImage = _addButtonTap
            .flatMapLatest { vc in
                return RxYPImagePicker.rx
                    .create(vc)
                    .flatMap { $0.pickedImage }
                    .take(1)
            }
            .share()

        /// I also added meals because I want to detect the update of meal information
        let progress = Observable.combineLatest(todayModel.day, userInfoModel.userInfo)

        output = Output(viewDidAppear: _viewDidAppear.asObservable(),
                        changeData: todayModel.changeData.asObservable(),
                        progress: progress)

        let mealWillAdd = PublishRelay<Meal>()

        pickedImage
            .compactMap { $0 }
            .flatMapLatest { PhotoManager.rx.save(image: $0) }
            .observeOn(MainScheduler.instance)
            .map { Meal(imagePath: $0, date: Date()) }
            .bind(to: mealWillAdd)
            .disposed(by: disposeBag)

        mealWillAdd
            .map { $0 }
            .bind(to: todayModel.addMeal)
            .disposed(by: disposeBag)

        /// Screen transition can't be made without viewDidAppear or later
        let showDetail = mealWillAdd.withLatestFrom(pickedImage) { ($1, $0) }
            .withLatestFrom(_viewDidAppear) { ($0, $1) }
            .map { ($0.0.0, $0.0.1) }
            .share()

        // MARK: - Processing to transition
        showDetail
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: {
                coordinator.showDetail(image: $0.0, meal: $0.1)
            })
            .disposed(by: disposeBag)

        _selectedItem
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: {
                coordinator.showEdit(mealCard: $0.0, meal: $0.1)
            })
            .disposed(by: disposeBag)

        _showDetailDay
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: {
                coordinator.showDetailDay(day: $0)
            })
            .disposed(by: disposeBag)
    }
}

extension TodayViewModel {

    struct Input {
        let viewDidAppear: AnyObserver<Void>
        let addButtonTap: AnyObserver<TodayViewController>
        let selectedItem: AnyObserver<(MealCardViewCell, Meal)>
        let showDetailDay: AnyObserver<Day>
    }

    struct Output {
        let viewDidAppear: Observable<Void>
        let changeData: Observable<RealmChangeset?>
        let progress: Observable<(Day, UserInfo)>
    }
}
