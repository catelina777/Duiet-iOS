//
//  Month.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import CoreData
import Foundation
import RxCoreData
import RxDataSources

struct Month {
    var id: UUID
    var date: String
    var createdAt: Date
    var updatedAt: Date
    var days: Set<DayEntity>

    init(date: Date) {
        id = UUID()
        self.date = date.toMonthKeyString()
        self.createdAt = date
        self.updatedAt = date
        days = Set<DayEntity>()
    }

    init(codableEntity: MonthCodable) {
        id = UUID(uuidString: codableEntity.id) ?? UUID()
        date = codableEntity.date
        createdAt = codableEntity.createdAt
        updatedAt = codableEntity.updatedAt
        days = Set<DayEntity>()
    }
}

extension Month: IdentifiableType {
    typealias Identity = String

    var identity: String { id.uuidString }
}

extension Month: Persistable {
    typealias T = MonthEntity

    static var entityName: String {
        T.className
    }

    static var primaryAttributeName: String {
        "id"
    }

    init(entity: Self.T) {
        id = entity.id
        date = entity.date
        createdAt = entity.createdAt
        updatedAt = entity.updatedAt
        days = entity.days
    }

    func update(_ entity: MonthEntity) {
        entity.id = id
        entity.date = date
        entity.createdAt = createdAt
        entity.updatedAt = updatedAt
        entity.days = days
        do {
            try entity.managedObjectContext?.save()
        } catch let error {
            logger.error(error)
        }
    }
}
