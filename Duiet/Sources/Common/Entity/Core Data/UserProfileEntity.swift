//
//  UserProfileEntity.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/16.
//  Copyright © 2019 duiet. All rights reserved.
//

import CoreData
import Foundation

@objc(UserProfileEntity)
final class UserProfileEntity: NSManagedObject {
    @NSManaged var activityLevel: String?
    @NSManaged var age: Int16
    @NSManaged var biologicalSex: String?
    @NSManaged var createdAt: Date?
    @NSManaged var height: Double
    @NSManaged var id: UUID?
    @NSManaged var updatedAt: Date?
    @NSManaged var weight: Double
}
