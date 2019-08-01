//
//  MonthsRepository.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/13.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift

protocol MonthsRepositoryProtocol {
    func find() -> Results<Month>
}

final class MonthsRepository: MonthsRepositoryProtocol {
    static let shared = MonthsRepository()

    private let realm: Realm

    private init() {
        realm = try! Realm()
    }

    func find() -> Results<Month> {
        return realm.objects(Month.self).sorted(byKeyPath: "createdAt")
    }
}
