//
//  MealService.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

protocol MealServiceProtocol {
    func add(_ meal: Meal, to day: DayEntity)
}

final class MealService: MealServiceProtocol {
    static let shared = MealService()
    private let repository: CoreDataRepositoryProtocol

    private init(repository: CoreDataRepositoryProtocol = CoreDataRepository.shared) {
        self.repository = repository
    }

    func add(_ meal: Meal, to day: DayEntity) {
        let entity = Meal(meal: meal, dayEntity: day)
        repository.update(entity)
    }
}
