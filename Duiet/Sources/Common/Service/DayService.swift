//
//  DayService.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift
import ToolKits

protocol DayServiceProtocol {
    func findAll() -> Observable<[Day]>
    func findOrCreate(day date: Date) -> DayEntity
    func delete(_ meals: [MealEntity])
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
                        sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: true)])
    }

    func findOrCreate(day date: Date) -> DayEntity {
        let dayEntity = repository.get(Day.self, key: "date", value: date.toDayKeyString())
        if let dayEntity = dayEntity {
            return dayEntity
        } else {
            let dayEntity = repository.create(Day.self)
            let monthEntity = findOrCreate(month: date)
            dayEntity.id = UUID()
            dayEntity.date = date.toDayKeyString()
            dayEntity.createdAt = date
            dayEntity.updatedAt = date
            dayEntity.month = monthEntity
            dayEntity.meals = Set<MealEntity>()
            do {
                try dayEntity.managedObjectContext?.save()
                logger.info(dayEntity)
            } catch let error {
                logger.error(error)
            }
            return dayEntity
        }
    }

    private func findOrCreate(month date: Date) -> MonthEntity {
        let monthEntity = repository.get(Month.self, key: "date", value: date.toMonthKeyString())
        if let monthEntity = monthEntity {
            return monthEntity
        } else {
            let monthEntity = repository.create(Month.self)
            monthEntity.id = UUID()
            monthEntity.date = date.toMonthKeyString()
            monthEntity.createdAt = date
            monthEntity.updatedAt = date
            monthEntity.days = Set<DayEntity>()
            do {
                try monthEntity.managedObjectContext?.save()
                logger.info(monthEntity)
            } catch let error {
                logger.error(error)
            }
            return monthEntity
        }
    }

    func delete(_ meals: [MealEntity]) {
        meals.forEach {
            repository.delete($0)
        }
        logger.info(meals)
    }
}
