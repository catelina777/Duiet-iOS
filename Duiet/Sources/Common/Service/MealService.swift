//
//  MealService.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

protocol MealServiceProtocol {
    func add(_ meal: Meal, to dayEntity: DayEntity) -> MealEntity?
}

final class MealService: MealServiceProtocol {
    static let shared = MealService()
    private let repository: CoreDataRepositoryProtocol

    private init(repository: CoreDataRepositoryProtocol = CoreDataRepository.shared) {
        self.repository = repository
    }

    func add(_ meal: Meal, to dayEntity: DayEntity) -> MealEntity? {
        let target = repository.create(Meal.self)
        target.id = meal.id
        target.imageId = meal.imageId
        target.createdAt = meal.createdAt
        target.updatedAt = meal.updatedAt
        target.day = dayEntity
        target.foods = meal.foods
        do {
            try target.managedObjectContext?.save()
            Logger.shared.info(meal)
            return target
        } catch let error {
            Logger.shared.error(error)
            return nil
        }
    }
}
