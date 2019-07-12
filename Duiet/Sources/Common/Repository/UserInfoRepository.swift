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
    func get() -> Results<UserInfo>
}

final class UserInfoRepository: UserInfoRepositoryProtocol {

    static let shared = UserInfoRepository()

    private let realm: Realm

    init() {
        realm = try! Realm()
    }

    func get() -> Results<UserInfo> {
        return realm.objects(UserInfo.self).filter("id == 0")
    }
}
