//
//  UserInfoRepository.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/13.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift
import RxRealm
import RxSwift

protocol UserInfoRepositoryProtocol {
    func add(userInfo: UserInfo)

    /// Use on the premise that there is always an acquisition target
    func get() -> Observable<UserInfo>
}

final class UserInfoRepository: UserInfoRepositoryProtocol {
    static let shared = UserInfoRepository()

    private let realm: Realm

    private init() {
        realm = try! Realm()
    }

    func add(userInfo: UserInfo) {
        try! realm.write {
            realm.add(userInfo, update: .modified)
        }
    }

    func get() -> Observable<UserInfo> {
        Observable.collection(from: realm.objects(UserInfo.self))
            .compactMap { $0.first }
    }
}
