//
//  FoodService.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift

protocol FoodServiceProtocol {
    func findAll() -> Observable<[FoodEntity]>
    func find(by name: String) -> Observable<[FoodEntity]>
    func add(_ food: Food, mealEntity: MealEntity)
    func update(_ food: Food, name: String, calorie: Double, multiple: Double, updatedAt: Date) -> Food
    func delete(_ food: Food)
}

final class FoodService: FoodServiceProtocol {
    static let shared = FoodService()
    private let repository: CoreDataRepositoryProtocol

    private init(repository: CoreDataRepositoryProtocol = CoreDataRepository.shared) {
        self.repository = repository
    }

    func findAll() -> Observable<[FoodEntity]> {
        repository.find(type: Food.self,
                        predicate: NSPredicate(format: "name != %@", argumentArray: [""]),
                        sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)])
    }

    func find(by name: String) -> Observable<[FoodEntity]> {
        repository.find(type: Food.self,
                        predicate: NSPredicate(format: "name CONTAINS[c] %@", argumentArray: [name]),
                        sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)])
    }

    func add(_ food: Food, mealEntity: MealEntity) {
        let updatedEntity = Food(food: food, mealEntity: mealEntity, updatedAt: Date())
        repository.update(entity: updatedEntity)
    }

    func update(_ food: Food, name: String, calorie: Double, multiple: Double, updatedAt: Date) -> Food {
        let updatedEntity = Food(from: food, name: name, calorie: calorie, multiple: multiple, updatedAt: updatedAt)
        repository.update(entity: updatedEntity)
        return updatedEntity
    }

    func delete(_ food: Food) {
        repository.delete(entity: food)
    }
}
