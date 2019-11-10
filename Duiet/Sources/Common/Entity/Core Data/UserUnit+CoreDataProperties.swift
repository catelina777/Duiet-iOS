//
//  UserUnit+CoreDataProperties.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/10.
//  Copyright © 2019 duiet. All rights reserved.
//
//

import CoreData
import Foundation

extension UserUnit {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<UserUnit> {
        return NSFetchRequest<UserUnit>(entityName: "UserUnit")
    }

    @NSManaged var createdAt: Date?
    @NSManaged var energyUnitRow: Int16
    @NSManaged var heightUnitRow: Int16
    @NSManaged var id: Int16
    @NSManaged var updatedAt: Date?
    @NSManaged var weightUnitRow: Int16
}
