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
    var didTapAddButton: AnyObserver<TodayViewController> { get }
    var didTapDeleteButton: AnyObserver<Void> { get }
    var selectedItem: AnyObserver<(MealCardViewCell, Meal, Int)> { get }
    var showDetailDay: AnyObserver<Day> { get }
    var isEditMode: AnyObserver<Bool> { get }
}

protocol TodayViewModelOutput {
    var progress: Observable<(Day, UserInfo)> { get }
    var isEditMode: Observable<Bool> { get }
    var isEnableTrashButton: Observable<Bool> { get }
}

protocol TodayViewModelState {
    var userInfoValue: UserInfo { get }
    var dayValue: Day { get }
    var meals: [Meal] { get }
    var title: String { get }
    var unitCollectionValue: UnitCollection { get }
    var deletionTargetMeals: BehaviorRelay<[Meal]> { get }
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

    var unitCollectionValue: UnitCollection {
        unitCollectionModel.state.unitCollectionValue
    }

    let deletionTargetMeals = BehaviorRelay<[Meal]>(value: [])

    private let userInfoModel: UserInfoModelProtocol
    private let todayModel: TodayModelProtocol
    private let unitCollectionModel: UnitCollectionModelProtocol

    private let disposeBag = DisposeBag()

    init(coordinator: TodayCoordinator,
         userInfoModel: UserInfoModelProtocol,
         todayModel: TodayModelProtocol,
         unitCollectionModel: UnitCollectionModelProtocol = UnitCollectionModel.shared) {
        self.userInfoModel = userInfoModel
        self.todayModel = todayModel
        self.unitCollectionModel = unitCollectionModel

        let viewDidAppear = PublishRelay<Void>()
        let didTapAddButton = PublishRelay<TodayViewController>()
        let didTapDeleteButton = PublishRelay<Void>()
        let selectedItem = PublishRelay<(MealCardViewCell, Meal, Int)>()
        let showDetailDay = PublishRelay<Day>()
        let isEditMode = PublishRelay<Bool>()

        input = Input(viewDidAppear: viewDidAppear.asObserver(),
                      didTapAddButton: didTapAddButton.asObserver(),
                      didTapDeleteButton: didTapDeleteButton.asObserver(),
                      selectedItem: selectedItem.asObserver(),
                      showDetailDay: showDetailDay.asObserver(),
                      isEditMode: isEditMode.asObserver())

        let pickedImage = didTapAddButton
            .flatMapLatest {
                RxYPImagePicker.rx
                    .create($0)
                    .flatMap { $0.pickedImage }
                    .take(1)
            }
            .share()

        /// I also added meals because I want to detect the update of meal information
        let progress = Observable.combineLatest(todayModel.output.day, userInfoModel.output.userInfo)

        let isEnableTrashButton = deletionTargetMeals
            .map { $0.isEmpty }
            .share()

        output = Output(progress: progress,
                        isEditMode: isEditMode.asObservable(),
                        isEnableTrashButton: isEnableTrashButton)

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
            .withLatestFrom(viewDidAppear) { ($0, $1) }
            .map { ($0.0.0, $0.0.1) }
            .share()

        /// Delete meals
        didTapDeleteButton.withLatestFrom(deletionTargetMeals)
            .bind(to: todayModel.state.delete)
            .disposed(by: disposeBag)

        // MARK: - Processing to transition
        showDetail
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: {
                coordinator.showDetail(image: $0.0, meal: $0.1)
            })
            .disposed(by: disposeBag)

        selectedItem
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: {
                coordinator.showEdit(mealCard: $0.0, meal: $0.1, row: $0.2)
            })
            .disposed(by: disposeBag)

        showDetailDay
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
        let didTapAddButton: AnyObserver<TodayViewController>
        let didTapDeleteButton: AnyObserver<Void>
        let selectedItem: AnyObserver<(MealCardViewCell, Meal, Int)>
        let showDetailDay: AnyObserver<Day>
        let isEditMode: AnyObserver<Bool>
    }

    struct Output: TodayViewModelOutput {
        let progress: Observable<(Day, UserInfo)>
        let isEditMode: Observable<Bool>
        let isEnableTrashButton: Observable<Bool>
    }
}
