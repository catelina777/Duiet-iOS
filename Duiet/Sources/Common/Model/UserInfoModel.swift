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

protocol UserInfoModelProtocol {
    var userInfo: BehaviorRelay<UserInfo> { get }
}

final class UserInfoModel: UserInfoModelProtocol {

    static let shared = UserInfoModel(repository: UserInfoRepository.shared)

    let userInfo = BehaviorRelay<UserInfo>(value: UserInfo())

    private let repository: UserInfoRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(repository: UserInfoRepositoryProtocol) {
        self.repository = repository

        let userInfoObject = repository.get()
        observe(userInfoObject: userInfoObject)
    }

    private func observe(userInfoObject: UserInfo?) {
        guard let userInfoObject = userInfoObject else { return }
        Observable.from(object: userInfoObject)
            .subscribe(onNext: { [weak self] userInfo in
                guard let me = self else { return }
                me.userInfo.accept(userInfo)
            })
            .disposed(by: disposeBag)
    }
}
