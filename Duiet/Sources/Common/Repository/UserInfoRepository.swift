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
    func get() -> UserInfo?
}

final class UserInfoRepository: UserInfoRepositoryProtocol {

    static let shared = UserInfoRepository()

    private let realm: Realm

    private init() {
        realm = try! Realm()
    }

    func get() -> UserInfo? {
        return realm.object(ofType: UserInfo.self, forPrimaryKey: 0)
    }
}
