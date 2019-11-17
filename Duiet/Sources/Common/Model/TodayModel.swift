//
//  TodayModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/05/25.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxCocoa
import RxRelay
import RxSwift

protocol TodayModelInput {}

protocol TodayModelOutput {
    var day: Observable<DayEntity> { get }
}

protocol TodayModelState {
    var dayEntityValue: DayEntity { get }
    var meals: [MealEntity] { get }
    var title: String { get }
    var date: Date { get }
    var delete: Binder<[Meal]> { get }

    func add(_ meal: Meal) -> MealEntity?
}

protocol TodayModelProtocol {
    var input: TodayModelInput { get }
    var output: TodayModelOutput { get }
    var state: TodayModelState { get }
}

final class TodayModel: TodayModelProtocol, TodayModelState {
    let input: TodayModelInput
    let output: TodayModelOutput
    var state: TodayModelState { self }

    // MARK: - State
    var dayEntityValue: DayEntity {
        day.value
    }

    var meals: [MealEntity] {
        Array(day.value.meals ?? [])
    }

    var title: String {
        day.value.createdAt?.toString() ?? ""
    }

    let date: Date

    private let day: BehaviorRelay<DayEntity>
    private let dayService: DayServiceProtocol
    private let disposeBag = DisposeBag()

    init(dayService: DayServiceProtocol = DayService.shared,
         date: Date = Date()) {
        self.dayService = dayService
        self.date = date
        day = BehaviorRelay<DayEntity>(value: dayService.findOrCreate(day: date))

        input = Input()
        output = Output(day: day.asObservable())
    }

    func add(_ meal: Meal) -> MealEntity? {
        dayService.add(meal, to: dayEntityValue)
    }

    var delete: Binder<[Meal]> {
        Binder<[Meal]>(self) { me, meals in
            me.dayService.delete(meals)
        }
    }
}

extension TodayModel {
    struct Input: TodayModelInput {}

    struct Output: TodayModelOutput {
        let day: Observable<DayEntity>
    }
}
