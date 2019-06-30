//
//  UserInfoModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/23.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RealmSwift
import RxRealm

final class UserInfoModel: RealmBaseModel {

    static let shared = UserInfoModel()

    let userInfo = BehaviorRelay<UserInfo>(value: UserInfo())

    override init() {
        super.init()

        let userInfoResult = get()
        observe(userInfoResult: userInfoResult)
    }

    private func get() -> Results<UserInfo> {
        return realm.objects(UserInfo.self).filter("id == 0")
    }

    private func observe(userInfoResult: Results<UserInfo>) {
        Observable.array(from: userInfoResult)
            .compactMap { $0.first }
            .subscribe(onNext: { [weak self] userInfo in
                guard let self = self else { return }
                self.userInfo.accept(userInfo)
            })
            .disposed(by: disposeBag)
    }
}
