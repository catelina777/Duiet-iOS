//
//  NewMeal+CoreDataProperties.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/10.
//  Copyright © 2019 duiet. All rights reserved.
//
//

import CoreData
import Foundation

extension NewMeal {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<NewMeal> {
        return NSFetchRequest<NewMeal>(entityName: "NewMeal")
    }

    @NSManaged var id: UUID?
    @NSManaged var imageId: String?
    @NSManaged var foods: NSSet?
}

// MARK: Generated accessors for foods
extension NewMeal {
    @objc(addFoodsObject:)
    @NSManaged func addToFoods(_ value: Food)

    @objc(removeFoodsObject:)
    @NSManaged func removeFromFoods(_ value: Food)

    @objc(addFoods:)
    @NSManaged func addToFoods(_ values: NSSet)

    @objc(removeFoods:)
    @NSManaged func removeFromFoods(_ values: NSSet)
}
