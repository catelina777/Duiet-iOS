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

final class UserInfoModel {

    static let shared = UserInfoModel(repository: UserInfoRepository.shared)

    let userInfo = BehaviorRelay<UserInfo>(value: UserInfo())

    private let repository: UserInfoRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(repository: UserInfoRepositoryProtocol) {
        self.repository = repository
        let userInfoResult = repository.get()
        observe(userInfoResult: userInfoResult)
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
