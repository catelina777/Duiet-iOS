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
    var userInfo: Observable<UserInfo> { get }
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

    // MARK: - State
    var userInfoValue: UserInfo {
        userInfo.value
    }

    private let userInfo: BehaviorRelay<UserInfo>
    private let repository: UserInfoRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(repository: UserInfoRepositoryProtocol) {
        self.repository = repository
        userInfo = BehaviorRelay<UserInfo>(value: repository.get())

        input = Input()
        output = Output(userInfo: userInfo.asObservable())
    }

    func add(userInfo: UserInfo) {
        repository.add(userInfo: userInfo)
    }
}

extension UserInfoModel {
    struct Input: UserInfoModelInput {}

    struct Output: UserInfoModelOutput {
        let userInfo: Observable<UserInfo>
    }
}
