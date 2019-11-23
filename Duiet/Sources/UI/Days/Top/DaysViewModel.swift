//
//  DaysViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/16.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

protocol DaysViewModelInput {
    var selectedDay: AnyObserver<Day> { get }
    var selectedMonth: AnyObserver<MonthEntity> { get }
}

protocol DaysViewModelOutput {
    var showDetailDay: Observable<Day> { get }
    var reloadData: Observable<Void> { get }
}

protocol DaysViewModelState {
    var daysValue: [Day] { get }
    var userProfileValue: UserProfile { get }
    var title: String { get }
    var unitCollectionValue: UnitCollection { get }
}

protocol DaysViewModelProtocol {
    var input: DaysViewModelInput { get }
    var output: DaysViewModelOutput { get }
    var state: DaysViewModelState { get }
}

final class DaysViewModel: DaysViewModelProtocol, DaysViewModelState {
    let input: DaysViewModelInput
    let output: DaysViewModelOutput
    var state: DaysViewModelState { self }

    // MARK: - State
    var daysValue: [Day] {
        daysModel.state.daysValue
    }

    var userProfileValue: UserProfile {
        userProfileModel.state.userProfileValue
    }

    var title: String {
        daysModel.state.title
    }

    var unitCollectionValue: UnitCollection {
        unitCollectionModel.state.unitCollectionValue
    }

    private let daysModel: DaysModelProtocol
    private let userProfileModel: UserProfileModelProtocol
    private let unitCollectionModel: UnitCollectionModelProtocol
    private let coordinator: DaysCoordinator
    private let disposeBag = DisposeBag()

    init(coordinator: DaysCoordinator,
         daysModel: DaysModelProtocol,
         userProfileModel: UserProfileModelProtocol = UserProfileModel.shared,
         unitCollectionModel: UnitCollectionModelProtocol = UnitCollectionModel.shared) {
        self.coordinator = coordinator
        self.daysModel = daysModel
        self.userProfileModel = userProfileModel
        self.unitCollectionModel = unitCollectionModel

        let _selectedDay = PublishRelay<Day>()
        let _selectedMonth = PublishRelay<MonthEntity>()
        input = Input(selectedDay: _selectedDay.asObserver(),
                      selectedMonth: _selectedMonth.asObserver())

        let reloadData = Observable.combineLatest(userProfileModel.output.userProfile,
                                                  unitCollectionModel.output.unitCollection)
            .map { _ in }
        output = Output(showDetailDay: _selectedDay.asObservable(),
                        reloadData: reloadData)

        _selectedMonth
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { month in
                coordinator.show(monthEntity: month)
            })
            .disposed(by: disposeBag)
    }
}

extension DaysViewModel {
    struct Input: DaysViewModelInput {
        let selectedDay: AnyObserver<Day>
        let selectedMonth: AnyObserver<MonthEntity>
    }

    struct Output: DaysViewModelOutput {
        let showDetailDay: Observable<Day>
        let reloadData: Observable<Void>
    }
}
