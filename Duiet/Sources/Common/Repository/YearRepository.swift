//
//  YearRepository.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/13.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift

protocol YearRepositoryProtocol {
    func find() -> Results<Month>
}

final class YearRepository: YearRepositoryProtocol {

    static let shared = YearRepository()

    private let realm: Realm

    private init() {
        realm = try! Realm()
    }

    func find() -> Results<Month> {
        return realm.objects(Month.self).sorted(byKeyPath: "createdAt")
    }
}
