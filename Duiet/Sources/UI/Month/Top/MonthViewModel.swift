//
//  MonthViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/16.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift

final class MonthViewModel {

    let input: Input
    let output: Output

    private let monthModel: MonthModelProtocol
    private let userInfoModel: UserInfoModel
    private let coordinator: MonthCoordinator
    private let disposeBag = DisposeBag()

    var userInfo: UserInfo {
        return userInfoModel.userInfo.value
    }

    var days: [Day] {
        return monthModel.days.value
    }

    init(coordinator: MonthCoordinator,
         model: MonthModelProtocol,
         month: Month? = nil) {
        self.coordinator = coordinator
        monthModel = model
        userInfoModel = UserInfoModel.shared
        input = Input()
        output = Output()
    }
}

extension MonthViewModel {

    struct Input {}

    struct Output {}
}
