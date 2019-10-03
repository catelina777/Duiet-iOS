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

protocol TodayModelProtocol {
    var day: BehaviorRelay<Day> { get }
    var meals: [Meal] { get }
    var addMeal: Binder<Meal> { get }
    var title: String { get }
    var date: Date { get }

    func reloadData(date: Date)
}

final class TodayModel: TodayModelProtocol {
    let day = BehaviorRelay<Day>(value: .init(date: Date()))

    var meals: [Meal] {
        day.value.meals.toArray()
    }

    lazy var title: String = {
        let now = Date()
        let date = day.value.createdAt
        let different = Calendar.current.dateComponents([.day], from: date, to: now).day
        if different == 0 {
            return SceneType.today.title
        } else {
            return  date.toString()
        }
    }()

    var date: Date {
        day.value.createdAt
    }

    private let repository: DayRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(repository: DayRepositoryProtocol = DayRepository.shared,
         date: Date = Date()) {
        self.repository = repository

        reloadData(date: date)
    }

    deinit {
        print("🧹🧹🧹 Day Model Parge 🧹🧹🧹")
    }

    var addMeal: Binder<Meal> {
        Binder(self) { me, meal in
            me.repository.add(meal: meal, to: me.day.value)
        }
    }

    func reloadData(date: Date) {
        let dayObject = repository.findOrCreate(day: date)
        day.accept(dayObject)
    }
}
