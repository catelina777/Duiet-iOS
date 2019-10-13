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
    func findAll() -> Results<Day>
}

final class DaysRepository: DaysRepositoryProtocol {
    static let shared = DaysRepository()

    private let realm: Realm

    private init() {
        realm = try! Realm()
    }

    func findAll() -> Results<Day> {
        realm.objects(Day.self).sorted(byKeyPath: "createdAt")
    }
}
