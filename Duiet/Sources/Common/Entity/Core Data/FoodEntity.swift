//
//  FoodEntity.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import CoreData
import Foundation

@objc(FoodEntity)
final class FoodEntity: NSManagedObject {
    @NSManaged var createdAt: Date?
    @NSManaged var updatedAt: Date?
    @NSManaged var name: String?
    @NSManaged var calorie: Double
    @NSManaged var multiple: Double
    @NSManaged var relativeX: Double
    @NSManaged var relativeY: Double
    @NSManaged var id: UUID
    @NSManaged var meal: MealEntity?
}
