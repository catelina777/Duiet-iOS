//
//  Food.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import CoreData
import Foundation
import RxCoreData
import RxDataSources

struct Food {
    var id: UUID
    var name: String
    var calorie: Double
    var multiple: Double
    var relativeX: Double
    var relativeY: Double
    var createdAt: Date
    var updatedAt: Date
    var meal: MealEntity

    init(relativeX: Double, relativeY: Double, mealEntity: MealEntity) {
        id = UUID()
        name = ""
        calorie = 0
        multiple = 1
        self.relativeX = relativeX
        self.relativeY = relativeY
        createdAt = Date()
        updatedAt = Date()
        meal = mealEntity
    }
}

extension Food: Equatable {}

extension Food: IdentifiableType {
    typealias Identity = String

    var identity: String { id.uuidString }
}

extension Food: Persistable {
    typealias T = FoodEntity

    static var entityName: String {
        T.className
    }

    static var primaryAttributeName: String {
        "id"
    }

    init(entity: FoodEntity) {
        id = entity.id
        name = entity.name
        calorie = entity.calorie
        multiple = entity.multiple
        relativeX = entity.relativeX
        relativeY = entity.relativeY
        createdAt = entity.createdAt
        updatedAt = entity.updatedAt
        meal = entity.meal
    }

    func update(_ entity: FoodEntity) {
        entity.id = id
        entity.name = name
        entity.calorie = calorie
        entity.multiple = multiple
        entity.relativeX = relativeX
        entity.relativeY = relativeY
        entity.createdAt = createdAt
        entity.updatedAt = updatedAt
        entity.meal = meal
        do {
            try entity.managedObjectContext?.save()
        } catch let error {
            Logger.shared.error(error)
        }
    }

    func build(coreDataRepository: CoreDataRepositoryProtocol = CoreDataRepository.shared) -> FoodEntity {
        let entity = coreDataRepository.create(type(of: self))
        entity.id = id
        entity.name = name
        entity.calorie = calorie
        entity.multiple = multiple
        entity.relativeX = relativeX
        entity.relativeY = relativeY
        entity.createdAt = createdAt
        entity.updatedAt = updatedAt
        entity.meal = meal
        return entity
    }
}
