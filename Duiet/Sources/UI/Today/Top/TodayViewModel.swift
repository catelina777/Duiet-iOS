//
//  TodayViewModel.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/23.
//  Copyright © 2019 duiet. All rights reserved.
//

import RealmSwift
import RxCocoa
import RxRealm
import RxRelay
import RxSwift
import UIKit

protocol TodayViewModelInput {
    var viewDidAppear: AnyObserver<Void> { get }
    var willLoadData: AnyObserver<Void> { get }
    var addButtonTap: AnyObserver<TodayViewController> { get }
    var selectedItem: AnyObserver<(MealCardViewCell, Meal, Int)> { get }
    var showDetailDay: AnyObserver<Day> { get }
}

protocol TodayViewModelOutput {
    var didLoadData: Observable<Void> { get }
    var progress: Observable<(Day, UserInfo)> { get }
}

protocol TodayViewModelState {
    var userInfoValue: UserInfo { get }
    var dayValue: Day { get }
    var meals: [Meal] { get }
    var title: String { get }
}

protocol TodayViewModelProtocol {
    var input: TodayViewModelInput { get }
    var output: TodayViewModelOutput { get }
    var state: TodayViewModelState { get }
}

final class TodayViewModel: TodayViewModelProtocol, TodayViewModelState {
    let input: TodayViewModelInput
    let output: TodayViewModelOutput
    var state: TodayViewModelState { return self }

    // MARK: - State
    var userInfoValue: UserInfo {
        userInfoModel.state.userInfoValue
    }

    var dayValue: Day {
        todayModel.state.dayValue
    }

    var meals: [Meal] {
        todayModel.state.meals
    }

    var title: String {
        todayModel.state.title
    }

    let userInfoModel: UserInfoModelProtocol
    let todayModel: TodayModelProtocol

    private let disposeBag = DisposeBag()

    init(coordinator: TodayCoordinator,
         userInfoModel: UserInfoModelProtocol,
         todayModel: TodayModelProtocol) {
        self.userInfoModel = userInfoModel
        self.todayModel = todayModel

        let _viewDidAppear = PublishRelay<Void>()
        let _willLoadData = PublishRelay<Void>()
        let _addButtonTap = PublishRelay<TodayViewController>()
        let _selectedItem = PublishRelay<(MealCardViewCell, Meal, Int)>()
        let _showDetailDay = PublishRelay<Day>()

        input = Input(viewDidAppear: _viewDidAppear.asObserver(),
                      willLoadData: _willLoadData.asObserver(),
                      addButtonTap: _addButtonTap.asObserver(),
                      selectedItem: _selectedItem.asObserver(),
                      showDetailDay: _showDetailDay.asObserver())

        /// Reload the data to be displayed when the screen is displayed to correspond to the date
        let didLoadData = _willLoadData
            .do(onNext: { todayModel.state.reloadData(date: Date()) })

        let pickedImage = _addButtonTap
            .flatMapLatest {
                RxYPImagePicker.rx
                    .create($0)
                    .flatMap { $0.pickedImage }
                    .take(1)
            }
            .share()

        /// I also added meals because I want to detect the update of meal information
        let progress = Observable.combineLatest(todayModel.output.day, userInfoModel.output.userInfo)

        output = Output(didLoadData: didLoadData,
                        progress: progress)

        let mealWillAdd = pickedImage
            .compactMap { $0 }
            .flatMapLatest { PhotoRepository.shared.save(image: $0) }
            .observeOn(MainScheduler.instance)
            .map { Meal(imagePath: $0, date: todayModel.state.date) }
            .share()

        mealWillAdd
            .map { $0 }
            .bind(to: todayModel.state.add)
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
                coordinator.showEdit(mealCard: $0.0, meal: $0.1, row: $0.2)
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
    struct Input: TodayViewModelInput {
        let viewDidAppear: AnyObserver<Void>
        let willLoadData: AnyObserver<Void>
        let addButtonTap: AnyObserver<TodayViewController>
        let selectedItem: AnyObserver<(MealCardViewCell, Meal, Int)>
        let showDetailDay: AnyObserver<Day>
    }

    struct Output: TodayViewModelOutput {
        let didLoadData: Observable<Void>
        let progress: Observable<(Day, UserInfo)>
    }
}
