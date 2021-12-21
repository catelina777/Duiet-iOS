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
    typealias T = UserProfileEntity

    static var entityName: String {
        T.className
    }

    static var primaryAttributeName: String {
        "id"
    }

    init(entity: Self.T) {
        id = entity.id
        age = entity.age
        biologicalSex = entity.biologicalSex
        height = entity.height
        weight = entity.weight
        activityLevel = entity.activityLevel
        createdAt = entity.createdAt
        updatedAt = entity.updatedAt
    }

    func update(_ entity: UserProfileEntity) {
        entity.id = id
        entity.age = age
        entity.biologicalSex = biologicalSex
        entity.height = height
        entity.weight = weight
        entity.activityLevel = activityLevel
        entity.createdAt = createdAt
        entity.updatedAt = updatedAt
        do {
            try entity.managedObjectContext?.save()
        } catch let error {
            logger.error(error)
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
