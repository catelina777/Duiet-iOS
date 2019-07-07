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
    let dayModel: DayModelProtocol

    private let coordinator: DayCoordinator

    private let disposeBag = DisposeBag()

    var meals: [Meal] {
        return dayModel.meals.value
    }

    init(coordinator: DayCoordinator,
         model: DayModelProtocol,
         date: Date? = nil) {
        self.coordinator = coordinator
        self.userInfoModel = UserInfoModel.shared
        self.dayModel = model

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
        let progress = Observable.combineLatest(dayModel.day, userInfoModel.userInfo, dayModel.meals)
            .map { ($0.0, $0.1) }

        output = Output(changeData: dayModel.changeData.asObservable(),
                        progress: progress)

        pickedImage
            .compactMap { $0 }
            .flatMapLatest { PhotoManager.rx.save(image: $0) }
            .map { Meal(imagePath: $0) }
            .bind(to: meal)
            .disposed(by: disposeBag)

        meal
            .map { $0 }
            .bind(to: dayModel.addMeal)
            .disposed(by: disposeBag)

        // MARK: - Processing to transition
        showDetail
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] image, meal in
                guard let self = self else { return }
                self.coordinator.showDetail(image: image, meal: meal)
            })
            .disposed(by: disposeBag)

        editDetail
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] card, meal in
                guard let self = self else { return }
                self.coordinator.showEdit(mealCard: card, meal: meal)
            })
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
        let changeData: Observable<RealmChangeset?>
        let progress: Observable<(Day, UserInfo)>
    }
}
