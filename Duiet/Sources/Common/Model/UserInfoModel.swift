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

protocol UserInfoModelInput {}

protocol UserInfoModelOutput {
    var userInfo: BehaviorRelay<UserInfo> { get }
}

protocol UserInfoModelState {
    var userInfoValue: UserInfo { get }

    func add(userInfo: UserInfo)
}

protocol UserInfoModelProtocol {
    var input: UserInfoModelInput { get }
    var output: UserInfoModelOutput { get }
    var state: UserInfoModelState { get }
}

final class UserInfoModel: UserInfoModelProtocol, UserInfoModelState {
    // MARK: - Singleton
    static let shared = UserInfoModel(repository: UserInfoRepository.shared)

    let input: UserInfoModelInput
    let output: UserInfoModelOutput
    var state: UserInfoModelState { return self }

    private let repository: UserInfoRepositoryProtocol
    private let disposeBag = DisposeBag()

    // MARK: - State
    var userInfoValue: UserInfo {
        userInfo.value
    }

    private let userInfo = BehaviorRelay<UserInfo>(value: UserInfo())

    init(repository: UserInfoRepositoryProtocol) {
        self.repository = repository
        let addUserInfo = PublishRelay<UserInfo>()
        input = Input(addUserInfo: addUserInfo.asObserver())

        output = Output(userInfo: userInfo)

        repository.get()
            .compactMap { $0.first }
            .bind(to: userInfo)
            .disposed(by: disposeBag)
    }

    func add(userInfo: UserInfo) {
        repository.add(userInfo: userInfo)
    }
}

extension UserInfoModel {
    struct Input: UserInfoModelInput {
        var addUserInfo: AnyObserver<UserInfo>
    }

    struct Output: UserInfoModelOutput {
        let userInfo: BehaviorRelay<UserInfo>
    }
}
