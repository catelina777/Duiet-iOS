//
//  DaysRepository.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/05.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

protocol DaysRepositoryProtocol {
    func findAll() -> Results<Day>
    func find(month: Month) -> Month?
}

final class DaysRepository: DaysRepositoryProtocol {

    static let shared = DaysRepository()

    private let realm: Realm

    private init() {
        realm = try! Realm()
    }

    func findAll() -> Results<Day> {
        return realm.objects(Day.self).sorted(byKeyPath: "createdAt")
    }

    func find(month: Month) -> Month? {
        let date = month.createdAt
        let monthPrimaryKey = date.toMonthKeyString()
        return realm.object(ofType: Month.self, forPrimaryKey: monthPrimaryKey)
    }
}