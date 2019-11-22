//
//  MealEntity.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import CoreData
import Foundation

@objc(MealEntity)
final class MealEntity: NSManagedObject {
    @NSManaged var createdAt: Date?
    @NSManaged var updatedAt: Date?
    @NSManaged var imageId: String?
    @NSManaged var id: UUID
    @NSManaged var day: DayEntity?
    @NSManaged var foods: Set<FoodEntity>?
}

extension MealEntity {
    @objc(addFoodsObject:)
    @NSManaged func addToFoods(_ value: FoodEntity)

    @objc(removeFoodsObject:)
    @NSManaged func removeFromFoods(_ value: FoodEntity)

    @objc(addFoods:)
    @NSManaged func addToFoods(_ values: NSSet)

    @objc(removeFoods:)
    @NSManaged func removeFromFoods(_ values: NSSet)
}
