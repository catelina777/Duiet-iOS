//
//  DaysModel.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/06/26.
//  Copyright © 2019 Duiet. All rights reserved.
//

import Foundation
import RealmSwift
import RxRealm
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
    private let month: BehaviorRelay<Month?>

    lazy var title: String = {
        if let month = month.value {
            return month.createdAt.toYearMonthString()
        } else {
            return SceneType.days.title
        }
    }()

    private let disposeBag = DisposeBag()

    init(repository: DaysRepositoryProtocol = DaysRepository.shared,
         month: Month? = nil) {
        self.month = BehaviorRelay<Month?>(value: month)

        input = Input()
        output = Output()

        if let month = month {
            self.month.accept(month)
            self.days.accept(month.days.toArray())
        } else {
            let days = repository.findAll().toArray()
            self.days.accept(days)
        }
    }
}

extension DaysModel {
    struct Input: DaysModelInput {}

    struct Output: DaysModelOutput {}
}
