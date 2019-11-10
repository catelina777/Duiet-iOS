//
//  UserProfile+CoreDataProperties.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/10.
//  Copyright © 2019 duiet. All rights reserved.
//
//

import CoreData
import Foundation

extension UserProfile {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: "UserProfile")
    }

    @NSManaged var activityLevel: String?
    @NSManaged var age: Int16
    @NSManaged var biologicalSex: String?
    @NSManaged var createdAt: Date?
    @NSManaged var height: Double
    @NSManaged var id: Int16
    @NSManaged var updatedAt: Date?
    @NSManaged var weight: Double
}
