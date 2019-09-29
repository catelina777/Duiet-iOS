//
//  UserInfoModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/23.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift
import RxCocoa
import RxRealm
import RxRelay
import RxSwift

protocol UserInfoModelProtocol {
    var userInfo: BehaviorRelay<UserInfo> { get }
    var addUserInfo: Binder<UserInfo> { get }
}

final class UserInfoModel: UserInfoModelProtocol {
    static let shared = UserInfoModel(repository: UserInfoRepository.shared)

    let userInfo = BehaviorRelay<UserInfo>(value: UserInfo())

    private let repository: UserInfoRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(repository: UserInfoRepositoryProtocol) {
        self.repository = repository

        repository.get()
            .compactMap { $0.first }
            .bind(to: userInfo)
            .disposed(by: disposeBag)
    }

    var addUserInfo: Binder<UserInfo> {
        Binder(self) { me, userInfo in
            me.repository.add(userInfo: userInfo)
        }
    }
}
