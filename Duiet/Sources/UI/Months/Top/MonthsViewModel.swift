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
         monthsModel: MonthsModelProtocol) {
        self.coordinator = coordinator
        self.monthsModel = monthsModel

        let _itemDidSelect = PublishRelay<Month>()
        input = Input(itemDidSelect: _itemDidSelect.asObserver())
        output = Output(showSelectedMonth: _itemDidSelect.asObservable())
    }
}

extension MonthsViewModel {
    struct Input: MonthsViewModelInput {
        let itemDidSelect: AnyObserver<Month>
    }

    struct Output: MonthsViewModelOutput {
        let showSelectedMonth: Observable<Month>
    }
}
