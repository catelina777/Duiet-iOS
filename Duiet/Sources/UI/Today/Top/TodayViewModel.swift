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
    var didTapDeleteButton: AnyObserver<Void> { get }
    var addButtonDidTap: AnyObserver<Void> { get }
    var pickedImage: AnyObserver<UIImage> { get }
    var selectedItem: AnyObserver<(MealCardViewCell, Meal, Int)> { get }
    var showDetailDay: AnyObserver<Day> { get }
    var isEditMode: AnyObserver<Bool> { get }
}

protocol TodayViewModelOutput {
    var isEditMode: Observable<Bool> { get }
    var isEnableTrashButton: Observable<Bool> { get }
    var addButtonDidTap: Observable<Void> { get }
    var reloadData: Observable<Void> { get }
}

protocol TodayViewModelState {
    var userProfileValue: UserProfile { get }
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
    var userProfileValue: UserProfile {
        userProfileModel.state.userProfileValue
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

    private let userProfileModel: UserProfileModelProtocol
    private let todayModel: TodayModelProtocol
    private let unitCollectionModel: UnitCollectionModelProtocol

    private let disposeBag = DisposeBag()

    init(coordinator: TodayCoordinator,
         todayModel: TodayModelProtocol,
         userProfileModel: UserProfileModelProtocol = UserProfileModel.shared,
         unitCollectionModel: UnitCollectionModelProtocol = UnitCollectionModel.shared) {
        self.userProfileModel = userProfileModel
        self.todayModel = todayModel
        self.unitCollectionModel = unitCollectionModel

        let viewDidAppear = PublishRelay<Void>()
        let addButtonDidTap = PublishRelay<Void>()
        let pickedImage = PublishRelay<UIImage>()
        let didTapDeleteButton = PublishRelay<Void>()
        let selectedItem = PublishRelay<(MealCardViewCell, Meal, Int)>()
        let showDetailDay = PublishRelay<Day>()
        let isEditMode = PublishRelay<Bool>()

        input = Input(viewDidAppear: viewDidAppear.asObserver(),
                      didTapDeleteButton: didTapDeleteButton.asObserver(),
                      addButtonDidTap: addButtonDidTap.asObserver(),
                      pickedImage: pickedImage.asObserver(),
                      selectedItem: selectedItem.asObserver(),
                      showDetailDay: showDetailDay.asObserver(),
                      isEditMode: isEditMode.asObserver())

        let isEnableTrashButton = deletionTargetMeals
            .map { $0.isEmpty }
            .share()

        let reloadData = userProfileModel.output.userProfile
            .map { _ in }

        output = Output(isEditMode: isEditMode.asObservable(),
                        isEnableTrashButton: isEnableTrashButton,
                        addButtonDidTap: addButtonDidTap.asObservable(),
                        reloadData: reloadData)

        let mealWillAdd = pickedImage
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
        let didTapDeleteButton: AnyObserver<Void>
        let addButtonDidTap: AnyObserver<Void>
        let pickedImage: AnyObserver<UIImage>
        let selectedItem: AnyObserver<(MealCardViewCell, Meal, Int)>
        let showDetailDay: AnyObserver<Day>
        let isEditMode: AnyObserver<Bool>
    }

    struct Output: TodayViewModelOutput {
        let isEditMode: Observable<Bool>
        let isEnableTrashButton: Observable<Bool>
        let addButtonDidTap: Observable<Void>
        var reloadData: Observable<Void>
    }
}
