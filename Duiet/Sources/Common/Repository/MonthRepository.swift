//
//  MonthRepository.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/05.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

protocol MonthRepositoryProtocol {
    func findAll() -> Results<Day>
    func find(month date: Date) -> Month?
}

class MonthRepository: MonthRepositoryProtocol {

    let realm: Realm

    init() {
        realm = try! Realm()
    }

    func findAll() -> Results<Day> {
        return realm.objects(Day.self).sorted(byKeyPath: "createdAt")
    }

    func find(month date: Date) -> Month? {
        let monthPrimaryKey = date.toMonthKeyString()
        return realm.object(ofType: Month.self, forPrimaryKey: monthPrimaryKey)
    }
}
