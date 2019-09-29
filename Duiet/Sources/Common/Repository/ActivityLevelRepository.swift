//
//  ActivityLevelRepository.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/09/28.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift
import RxRealm
import RxSwift

protocol ActivityLevelRepositoryProtocol {
    func add(activityLevel: ActivityLevel)
    func find() -> Observable<Results<ActivityLevel>>
}

final class ActivityLevelRepository: ActivityLevelRepositoryProtocol {
    static let shared = ActivityLevelRepository()

    private let realm: Realm

    private init() {
        realm = try! Realm()
    }

    func add(activityLevel: ActivityLevel) {
        try! realm.write {
            realm.add(activityLevel)
        }
    }

    func find() -> Observable<Results<ActivityLevel>> {
        let results = realm.objects(ActivityLevel.self)
            .sorted(byKeyPath: "createdAt", ascending: false)
        return Observable.collection(from: results)
    }
}
