//
//  MonthsViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/09.
//  Copyright © 2019 Duiet. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

protocol MonthsViewModelInput {
    var itemDidSelect: AnyObserver<MonthEntity> { get }
}

protocol MonthsViewModelOutput {
    var showSelectedMonth: Observable<MonthEntity> { get }
    var reloadData: Observable<Void> { get }
}

protocol MonthsViewModelState {
    var monthsValue: [MonthEntity] { get }
}

protocol MonthsViewModelProtocol {
    var input: MonthsViewModelInput { get }
    var output: MonthsViewModelOutput { get }
    var state: MonthsViewModelState { get }
}

final class MonthsViewModel: MonthsViewModelProtocol, MonthsViewModelState {
    let input: MonthsViewModelInput
    let output: MonthsViewModelOutput
    var state: MonthsViewModelState { self }

    // MARK: State
    var monthsValue: [MonthEntity] {
        monthsModel.state.monthsValue
    }

    private let monthsModel: MonthsModelProtocol
    private let coordinator: MonthsCoordinator
    private let disposeBag = DisposeBag()

    init(coordinator: MonthsCoordinator,
         monthsModel: MonthsModelProtocol,
         userProfileModel: UserProfileModelProtocol = UserProfileModel.shared,
         unitCollectionModel: UnitCollectionModelProtocol = UnitCollectionModel.shared) {
        self.coordinator = coordinator
        self.monthsModel = monthsModel

        let itemDidSelect = PublishRelay<MonthEntity>()
        input = Input(itemDidSelect: itemDidSelect.asObserver())

        let reloadData = Observable.combineLatest(userProfileModel.output.userProfile,
                                                  unitCollectionModel.output.unitCollection)
            .map { _ in }
        output = Output(showSelectedMonth: itemDidSelect.asObservable(),
                        reloadData: reloadData)
    }
}

extension MonthsViewModel {
    struct Input: MonthsViewModelInput {
        let itemDidSelect: AnyObserver<MonthEntity>
    }

    struct Output: MonthsViewModelOutput {
        let showSelectedMonth: Observable<MonthEntity>
        let reloadData: Observable<Void>
    }
}
