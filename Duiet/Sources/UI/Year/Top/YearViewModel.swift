//
//  YearViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/09.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class YearViewModel {

    let input: Input
    let output: Output

    private let yearModel: YearModelProtocol
    private let coordinator: YearCoordinator
    private let disposeBag = DisposeBag()

    var months: [Month] {
        return yearModel.months.value
    }

    init(coordinator: YearCoordinator,
         yearModel: YearModelProtocol) {
        self.coordinator = coordinator
        self.yearModel = yearModel

        let _itemDidSelect = PublishRelay<Month>()
        input = Input(itemDidSelect: _itemDidSelect.asObserver())
        output = Output(showSelectedMonth: _itemDidSelect.asObservable())
    }
}

extension YearViewModel {

    struct Input {
        let itemDidSelect: AnyObserver<Month>
    }

    struct Output {
        let showSelectedMonth: Observable<Month>
    }
}
