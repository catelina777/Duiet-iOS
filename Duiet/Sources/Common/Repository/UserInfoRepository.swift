//
//  UserInfoRepository.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/13.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

protocol UserInfoRepositoryProtocol {
    func add(userInfo: UserInfo)
    func get() -> Results<UserInfo>
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

    func get() -> Results<UserInfo> {
        realm.objects(UserInfo.self)
    }
}
