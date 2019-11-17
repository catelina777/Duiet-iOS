//
//  MonthsModel.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/06/27.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

protocol MonthsModelInput {}

protocol MonthsModelOutput {
    var months: Observable<[MonthEntity]> { get }
}

protocol MonthsModelState {
    var monthsValue: [MonthEntity] { get }
}

protocol MonthsModelProtocol {
    var input: MonthsModelInput { get }
    var output: MonthsModelOutput { get }
    var state: MonthsModelState { get }
}

final class MonthsModel: MonthsModelProtocol, MonthsModelState {
    let input: MonthsModelInput
    let output: MonthsModelOutput
    var state: MonthsModelState { self }

    var monthsValue: [MonthEntity] {
        months.value
    }

    private let months = BehaviorRelay<[MonthEntity]>(value: [])

    private let disposeBag = DisposeBag()

    init(monthService: MonthServiceProtocol = MonthService.shared) {
        input = Input()
        output = Output(months: monthService.findAll())
    }
}

extension MonthsModel {
    struct Input: MonthsModelInput {}

    struct Output: MonthsModelOutput {
        var months: Observable<[MonthEntity]>
    }
}
