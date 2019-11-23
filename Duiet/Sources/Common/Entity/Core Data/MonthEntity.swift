//
//  MonthEntity.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import CoreData
import Foundation

@objc(MonthEntity)
final class MonthEntity: NSManagedObject {
    @NSManaged var createdAt: Date?
    @NSManaged var updatedAt: Date?
    @NSManaged var id: UUID?
    @NSManaged var date: String?
    @NSManaged var days: Set<DayEntity>?
}

extension MonthEntity {
    @objc(addDaysObject:)
    @NSManaged func addToDays(_ value: DayEntity)

    @objc(removeDaysObject:)
    @NSManaged func removeFromDays(_ value: DayEntity)

    @objc(addDays:)
    @NSManaged func addToDays(_ values: NSSet)

    @objc(removeDays:)
    @NSManaged func removeFromDays(_ values: NSSet)
}
