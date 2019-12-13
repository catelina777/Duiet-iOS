//
//  Meal.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import CoreData
import Foundation
import RxCoreData
import RxDataSources
import ToolKits

struct Meal {
    var id: UUID
    var imageId: String
    var createdAt: Date
    var updatedAt: Date
    var day: DayEntity
    var foods: Set<FoodEntity>

    init(imageId: String, dayEntity: DayEntity, date: Date) {
        id = UUID()
        self.imageId = imageId
        createdAt = date
        updatedAt = date
        day = dayEntity
        foods = Set<FoodEntity>()
    }

    init(codableEntity: MealCodable, dayEntity: DayEntity) {
        id = UUID(uuidString: codableEntity.id) ?? UUID()
        imageId = codableEntity.imageId
        createdAt = codableEntity.createdAt
        updatedAt = codableEntity.updatedAt
        day = dayEntity
        foods = Set<FoodEntity>()
    }
}

extension Meal: IdentifiableType {
    typealias Identity = String

    var identity: String { id.uuidString }
}

extension Meal: Persistable {
    typealias T = MealEntity

    static var entityName: String {
        T.className
    }

    static var primaryAttributeName: String {
        "id"
    }

    init(entity: Self.T) {
        id = entity.id
        imageId = entity.imageId
        createdAt = entity.createdAt
        updatedAt = entity.updatedAt
        day = entity.day
        foods = entity.foods
    }

    func update(_ entity: MealEntity) {
        entity.id = id
        entity.imageId = imageId
        entity.createdAt = createdAt
        entity.updatedAt = updatedAt
        entity.day = day
        entity.foods = foods
        do {
            try entity.managedObjectContext?.save()
        } catch let error {
            logger.error(error)
        }
    }
}
