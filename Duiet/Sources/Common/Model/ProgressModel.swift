//
//  ProgressModel.swift
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

final class ProgressModel: NSObject {

    var userInfoValue: UserInfo {
        return userInfo.value
    }

    let userInfo = BehaviorRelay<UserInfo>(value: UserInfo())

    private let realm: Realm

    private let disposeBag = DisposeBag()

    override init() {
        realm = try! Realm()

        let userInfoResult = realm.objects(UserInfo.self)
            .filter("id == 0")

        super.init()

        Observable.array(from: userInfoResult)
            .compactMap { $0.first }
            .subscribe(onNext: { [weak self] userInfo in
                guard let self = self else { return }
                self.userInfo.accept(userInfo)
            })
            .disposed(by: disposeBag)
    }
}
