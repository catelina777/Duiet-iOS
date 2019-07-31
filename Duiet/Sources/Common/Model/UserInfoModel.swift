//
//  UserInfoModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/23.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift
import RxRealm
import RxRelay
import RxSwift

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

        let userInfoResults = repository.get()
        observe(userInfoResults: userInfoResults)
    }

    /// Observe changes in userinfo
    ///
    /// - Parameter userInfoResults: UserInfo results find from repository
    private func observe(userInfoResults: Results<UserInfo>) {
        Observable.array(from: userInfoResults)
            .map { $0.first }
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] userInfo in
                guard let me = self else { return }
                me.userInfo.accept(userInfo)
            })
            .disposed(by: disposeBag)
    }
}
