//
//  Day.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import CoreData
import Foundation
import RxCoreData
import RxDataSources

struct Day {
    var id: UUID
    var date: String
    var createdAt: Date
    var updatedAt: Date
    var month: MonthEntity?
    var meals: Set<MealEntity>
}

extension Day: IdentifiableType {
    typealias Identity = String

    var identity: String { id.uuidString }
}

extension Day: Persistable {
    typealias T = DayEntity

    static var entityName: String {
        T.className
    }

    static var primaryAttributeName: String {
        "id"
    }

    init(entity: Self.T) {
        id = entity.id ?? UUID()
        date = entity.date ?? Date().toDayKeyString()
        createdAt = entity.createdAt ?? Date()
        updatedAt = entity.updatedAt ?? Date()
        month = entity.month
        meals = entity.meals ?? Set<MealEntity>()
    }

    func update(_ entity: DayEntity) {
        entity.id = id
        entity.date = date
        entity.createdAt = createdAt
        entity.updatedAt = updatedAt
        entity.month = month
        entity.meals = meals
        do {
            try entity.managedObjectContext?.save()
        } catch let error {
            Logger.shared.error(error)
        }
    }
}

extension Day {
    var totalCalorie: Double {
        meals.reduce(into: 0) { $0 += $1.foods?.reduce(into: 0) { $0 += $1.calorie * $1.multiple } ?? 0 }
    }
}
