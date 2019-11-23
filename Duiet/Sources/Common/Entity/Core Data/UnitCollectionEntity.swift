//
//  UnitCollectionEntity.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/16.
//  Copyright © 2019 duiet. All rights reserved.
//

import CoreData
import Foundation

@objc(UnitCollectionEntity)
final class UnitCollectionEntity: NSManagedObject {
    @NSManaged var createdAt: Date?
    @NSManaged var energyUnitRow: Int16
    @NSManaged var heightUnitRow: Int16
    @NSManaged var id: UUID?
    @NSManaged var updatedAt: Date?
    @NSManaged var weightUnitRow: Int16
}
