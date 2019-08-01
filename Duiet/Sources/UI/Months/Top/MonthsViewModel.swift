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

final class MonthsViewModel {
    let input: Input
    let output: Output

    private let monthsModel: MonthsModelProtocol
    private let coordinator: MonthsCoordinator
    private let disposeBag = DisposeBag()

    var months: [Month] {
        return monthsModel.months.value
    }

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
    struct Input {
        let itemDidSelect: AnyObserver<Month>
    }

    struct Output {
        let showSelectedMonth: Observable<Month>
    }
}
