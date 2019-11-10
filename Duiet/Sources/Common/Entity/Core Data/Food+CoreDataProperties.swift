//
//  Food+CoreDataProperties.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/10.
//  Copyright © 2019 duiet. All rights reserved.
//
//

import CoreData
import Foundation

extension Food {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<Food> {
        return NSFetchRequest<Food>(entityName: "Food")
    }

    @NSManaged var calorie: Double
    @NSManaged var id: UUID?
    @NSManaged var mealId: UUID?
    @NSManaged var multiple: Double
    @NSManaged var relativeX: Double
    @NSManaged var relativeY: Double
    @NSManaged var meal: NewMeal?
}
