//
//  TodayModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/05/25.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift
import RxCocoa
import RxRealm
import RxRelay
import RxSwift

protocol TodayModelProtocol {
    var changeData: PublishRelay<RealmChangeset?> { get }
    var contentDidDelete: PublishRelay<Void> { get }
    var day: BehaviorRelay<Day> { get }
    var addMeal: Binder<Meal> { get }
    var title: String { get }
    var date: Date { get }
}

final class TodayModel: TodayModelProtocol {
    let changeData = PublishRelay<RealmChangeset?>()
    let contentDidDelete = PublishRelay<Void>()
    let day: BehaviorRelay<Day>

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
        return day.value.createdAt
    }

    private let repository: DayRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(repository: DayRepositoryProtocol = DayRepository.shared,
         date: Date = Date()) {
        self.repository = repository
        self.day = BehaviorRelay<Day>(value: .init(date: date))

        let day = repository.findOrCreate(day: date)
        observe(day: day)

        let mealResults = repository.find(meals: date)
        observe(mealResultsChangeset: mealResults)
    }

    deinit {
        print("🧹🧹🧹 Day Model Parge 🧹🧹🧹")
    }

    var addMeal: Binder<Meal> {
        return Binder(self) { me, meal in
            me.repository.add(meal: meal, to: me.day.value)
        }
    }

    /// Detect change of day from change of meals
    ///
    /// - Parameter day: Day model find from repository
    private func observe(day: Day) {
        self.day.accept(day)
        changeData.withLatestFrom(self.day)
            .subscribe(onNext: { [weak self] day in
                guard let self = self else { return }
                self.day.accept(day)
            })
            .disposed(by: disposeBag)
    }

    /// Detect changes in meals
    ///
    /// - Parameter mealResults: Meal results find from repository
    private func observe(mealResultsChangeset mealResults: Results<Meal>) {
        Observable.changeset(from: mealResults)
            .map { $1 }
            .subscribe(onNext: { [weak self] changeset in
                guard let self = self else { return }
                self.changeData.accept(changeset)
            })
            .disposed(by: disposeBag)
    }
}
