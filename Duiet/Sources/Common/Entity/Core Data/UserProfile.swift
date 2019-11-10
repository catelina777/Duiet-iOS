//
//  UserProfile.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/10.
//  Copyright © 2019 duiet. All rights reserved.
//

import CoreData
import Foundation
import RxCoreData
import RxDataSources

struct UserProfile {
    var id: UUID
    var age: Int16
    var biologicalSex: String
    var height: Double
    var weight: Double
    var activityLevel: String
    var createdAt: Date
    var updatedAt: Date
}

extension UserProfile: IdentifiableType {
    typealias Identity = String

    var identity: String { id.uuidString }
}

extension UserProfile: Persistable {
    typealias T = NSManagedObject

    static var entityName: String {
        "UserProfile"
    }

    static var primaryAttributeName: String {
        "id"
    }

    init(entity: Self.T) {
        id = entity.value(forKey: "id") as! UUID
        age = entity.value(forKey: "age") as! Int16
        biologicalSex = entity.value(forKey: "biologicalSex") as! String
        height = entity.value(forKey: "height") as! Double
        weight = entity.value(forKey: "weight") as! Double
        activityLevel = entity.value(forKey: "activityLevel") as! String
        createdAt = entity.value(forKey: "createdAt") as! Date
        updatedAt = entity.value(forKey: "updatedAt") as! Date
    }

    func update(_ entity: NSManagedObject) {
        entity.setValue(id, forKey: "id")
        entity.setValue(age, forKey: "age")
        entity.setValue(biologicalSex, forKey: "biologicalSex")
        entity.setValue(height, forKey: "height")
        entity.setValue(weight, forKey: "weight")
        entity.setValue(activityLevel, forKey: "activityLevel")
        entity.setValue(createdAt, forKey: "createdAt")
        entity.setValue(updatedAt, forKey: "updatedAt")
        do {
            try entity.managedObjectContext?.save()
        } catch let error {
            Logger.shared.error(error)
        }
    }
}

extension UserProfile {
    var BMR: Double {
        calculate()
    }

    var TDEE: Double {
        calculate() * ActivityLevelType.get(activityLevel).magnification
    }

    private func calculate() -> Double {
        (height * 6.25) + (weight * 9.99) - (Double(age) * 4.92) + genderVariable(type: BiologicalSexType.get(biologicalSex))
    }

    private func genderVariable(type: BiologicalSexType) -> Double {
        type == .male ? 5 : -161
    }
}

enum BiologicalSexType: String {
    case male, female, other

    static func get(_ type: String) -> BiologicalSexType {
        switch type {
        case "male":
            return .male

        case "female":
            return .female

        default:
            return .other
        }
    }
}
