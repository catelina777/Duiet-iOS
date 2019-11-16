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
    var itemDidSelect: AnyObserver<Month> { get }
}

protocol MonthsViewModelOutput {
    var showSelectedMonth: Observable<Month> { get }
    var reloadData: Observable<Void> { get }
}

protocol MonthsViewModelData {
    var months: [Month] { get }
}

protocol MonthsViewModelProtocol {
    var input: MonthsViewModelInput { get }
    var output: MonthsViewModelOutput { get }
    var data: MonthsViewModelData { get }
}

final class MonthsViewModel: MonthsViewModelProtocol, MonthsViewModelData {
    let input: MonthsViewModelInput
    let output: MonthsViewModelOutput
    var data: MonthsViewModelData { return self }

    // MARK: State
    var months: [Month] {
        monthsModel.months.value
    }

    private let monthsModel: MonthsModelProtocol
    private let coordinator: MonthsCoordinator
    private let disposeBag = DisposeBag()

    init(coordinator: MonthsCoordinator,
         monthsModel: MonthsModelProtocol,
         userProfileModel: UserProfileModelProtocol = UserProfileModel.shared) {
        self.coordinator = coordinator
        self.monthsModel = monthsModel

        let itemDidSelect = PublishRelay<Month>()
        input = Input(itemDidSelect: itemDidSelect.asObserver())

        let reloadData = userProfileModel.output.userProfile
            .map { _ in }
        output = Output(showSelectedMonth: itemDidSelect.asObservable(),
                        reloadData: reloadData)
    }
}

extension MonthsViewModel {
    struct Input: MonthsViewModelInput {
        let itemDidSelect: AnyObserver<Month>
    }

    struct Output: MonthsViewModelOutput {
        let showSelectedMonth: Observable<Month>
        let reloadData: Observable<Void>
    }
}
