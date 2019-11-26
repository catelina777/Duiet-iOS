//
//  DayEntity.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import CoreData
import Foundation
import RxCoreData
import RxDataSources

@objc(DayEntity)
final class DayEntity: NSManagedObject {
    @NSManaged var createdAt: Date
    @NSManaged var updatedAt: Date
    @NSManaged var date: String
    @NSManaged var id: UUID
    @NSManaged var month: MonthEntity
    @NSManaged var meals: Set<MealEntity>
}

extension DayEntity {
    @objc(addMealsObject:)
    @NSManaged func addToMeals(_ value: MealEntity)

    @objc(removeMealsObject:)
    @NSManaged func removeFromMeals(_ value: MealEntity)

    @objc(addMeals:)
    @NSManaged func addToMeals(_ values: NSSet)

    @objc(removeMeals:)
    @NSManaged func removeFromMeals(_ values: NSSet)
}
