//
//  DayService.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift

protocol DayServiceProtocol {
    func findAll() -> Observable<[Day]>
    func findOrCreate(day date: Date) -> DayEntity
    func findOrCreate(month date: Date) -> MonthEntity
    func add(_ meal: Meal, to dayEntity: DayEntity) -> MealEntity?
    func delete(_ meals: [Meal])
}

final class DayService: DayServiceProtocol {
    static let shared = DayService()
    private let repository: CoreDataRepositoryProtocol

    private init(repository: CoreDataRepositoryProtocol = CoreDataRepository.shared) {
        self.repository = repository
    }

    func findAll() -> Observable<[Day]> {
        repository.find(Day.self,
                        predicate: nil,
                        sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)])
    }

    func findOrCreate(day date: Date) -> DayEntity {
        let dayEntity = repository.find(Day.self, key: "date", value: date.toDayKeyString())
        if let dayEntity = dayEntity {
            return dayEntity
        } else {
            let dayEntity = repository.create(Day.self)
            let monthEntity = findOrCreate(month: date)
            dayEntity.month = monthEntity
            do {
                try dayEntity.managedObjectContext?.save()
            } catch let error {
                Logger.shared.error(error)
            }
            return dayEntity
        }
    }

    func findOrCreate(month date: Date) -> MonthEntity {
        let monthEntity = repository.find(Month.self, key: "date", value: date.toMonthKeyString())
        if let monthEntity = monthEntity {
            return monthEntity
        } else {
            let monthEntity = repository.create(Month.self)
            do {
                try monthEntity.managedObjectContext?.save()
            } catch let error {
                Logger.shared.error(error)
            }
            return monthEntity
        }
    }

    func add(_ meal: Meal, to dayEntity: DayEntity) -> MealEntity? {
        let target = repository.create(Meal.self)
        target.id = meal.id
        target.imageId = meal.imageId
        target.createdAt = meal.createdAt
        target.updatedAt = meal.updatedAt
        target.day = meal.day
        target.foods = meal.foods
        do {
            try target.managedObjectContext?.save()
            return target
        } catch let error {
            Logger.shared.error(error)
            return nil
        }
    }

    func delete(_ meals: [Meal]) {
        meals.forEach {
            repository.delete(entity: $0)
        }
    }
}
