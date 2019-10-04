//
//  DaysRepository.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/05.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift
import RxRealm
import RxSwift

enum DaysRepositoryError: Error {
    case findMonthFailed
}

protocol DaysRepositoryProtocol {
    func findAll() -> Observable<Results<Day>>
    func find(month: Month) -> Observable<Month>
}

final class DaysRepository: DaysRepositoryProtocol {
    static let shared = DaysRepository()

    private let realm: Realm

    private init() {
        realm = try! Realm()
    }

    func findAll() -> Observable<Results<Day>> {
        Observable.collection(from: realm.objects(Day.self).sorted(byKeyPath: "createdAt"))
    }

    func find(month: Month) -> Observable<Month> {
        let date = month.createdAt
        let monthPrimaryKey = date.toMonthKeyString()
        let monthObject = realm.object(ofType: Month.self, forPrimaryKey: monthPrimaryKey)
        if let monthObject = monthObject {
            return Observable.from(object: monthObject)
        }
        return Observable.error(DaysRepositoryError.findMonthFailed)
    }
}
