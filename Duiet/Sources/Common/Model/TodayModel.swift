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
    var meals: [Meal] { get }
    var title: String { get }
    var date: Date { get }
    var add: Binder<Meal> { get }

    func reloadData(date: Date)
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

    var meals: [Meal] {
        day.value.meals.toArray()
    }

    var title: String {
        date.toString()
    }

    var date: Date {
        day.value.createdAt
    }

    let day = BehaviorRelay<Day>(value: .init(date: Date()))

    private let repository: DayRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(repository: DayRepositoryProtocol = DayRepository.shared,
         date: Date = Date()) {
        self.repository = repository

        input = Input()
        output = Output(day: day.asObservable())

        reloadData(date: date)
    }

    var add: Binder<Meal> {
        Binder(self) { me, meal in
            me.repository.add(meal: meal, to: me.day.value)
        }
    }

    func reloadData(date: Date) {
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
