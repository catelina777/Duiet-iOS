//
//  DaysModel.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/06/26.
//  Copyright © 2019 Duiet. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

protocol DaysModelInput {}

protocol DaysModelOutput {}

protocol DaysModelState {
    var daysValue: [Day] { get }
    var title: String { get }
}

protocol DaysModelProtocol {
    var input: DaysModelInput { get }
    var output: DaysModelOutput { get }
    var state: DaysModelState { get }
}

final class DaysModel: DaysModelProtocol, DaysModelState {
    let input: DaysModelInput
    let output: DaysModelOutput
    var state: DaysModelState { self }

    var daysValue: [Day] {
        days.value
    }

    private let days = BehaviorRelay<[Day]>(value: [])
    private let month: BehaviorRelay<MonthEntity?>

    lazy var title: String = {
        if let month = month.value {
            return month.createdAt?.toYearMonthString() ?? ""
        } else {
            return HistoryType.days.title
        }
    }()

    private let disposeBag = DisposeBag()

    init(dayService: DayServiceProtocol = DayService.shared,
         monthEntity: MonthEntity? = nil) {
        self.month = BehaviorRelay<MonthEntity?>(value: monthEntity)

        input = Input()
        output = Output()

        if let monthEntity = monthEntity {
            self.month.accept(monthEntity)
            self.days.accept(monthEntity.days.map { $0.map { Day(entity: $0) } } ?? [] )
        } else {
            dayService.findAll()
                .bind(to: days)
                .disposed(by: disposeBag)
        }
    }
}

extension DaysModel {
    struct Input: DaysModelInput {}

    struct Output: DaysModelOutput {}
}
