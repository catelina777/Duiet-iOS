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

struct Meal {
    var id: UUID
    var imageId: String
    var createdAt: Date
    var updatedAt: Date
    var day: DayEntity?
    var foods: Set<FoodEntity>

    init(id: UUID, imageId: String, createdAt: Date, updatedAt: Date, day: DayEntity, foods: Set<FoodEntity>) {
        self.id = id
        self.imageId = imageId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.day = day
        self.foods = foods
    }

    init(imageId: String, date: Date) {
        id = UUID()
        self.imageId = imageId
        self.createdAt = date
        self.updatedAt = date
        foods = Set<FoodEntity>()
    }

    init(meal: Meal, dayEntity: DayEntity) {
        id = meal.id
        imageId = meal.imageId
        createdAt = meal.createdAt
        foods = meal.foods
        day = dayEntity
        updatedAt = Date()
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
        id = entity.id!
        imageId = entity.imageId!
        createdAt = entity.createdAt!
        updatedAt = entity.updatedAt!
        day = entity.day!
        foods = entity.foods!
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
            Logger.shared.error(error)
        }
    }
}
