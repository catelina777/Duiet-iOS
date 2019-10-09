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
    var day: Observable<Day> { get }
}

protocol TodayModelState {
    var dayValue: Day { get }
    var meals: [Meal] { get }
    var title: String { get }
    var date: Date { get }
    var add: Binder<Meal> { get }

    func reloadData()
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

    var dayValue: Day {
        day.value
    }

    var meals: [Meal] {
        day.value.meals.toArray()
    }

    var title: String {
        date.toString()
    }

    let date: Date
    let day: BehaviorRelay<Day>

    private let repository: DayRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(repository: DayRepositoryProtocol = DayRepository.shared,
         date: Date = Date()) {
        self.repository = repository
        self.date = date
        day = BehaviorRelay<Day>(value: .init(date: date))

        input = Input()
        output = Output(day: day.asObservable())

        reloadData()
    }

    var add: Binder<Meal> {
        Binder(self) { me, meal in
            me.repository.add(meal: meal, to: me.day.value)
        }
    }

    func reloadData() {
        let dayObject = repository.findOrCreate(day: date)
        day.accept(dayObject)
    }

    deinit {
        print("🧹🧹🧹 TodayModel Parge 🧹🧹🧹")
    }
}

extension TodayModel {
    struct Input: TodayModelInput {}

    struct Output: TodayModelOutput {
        let day: Observable<Day>
    }
}
