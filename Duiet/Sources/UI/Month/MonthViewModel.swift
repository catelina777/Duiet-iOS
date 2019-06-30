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

    private let monthModel: MonthModel
    private let userInfoModel: UserInfoModel

    var userInfo: UserInfo {
        return userInfoModel.userInfo.value
    }

    var days: [Day] {
        return monthModel.days.value
    }

    init() {
        monthModel = MonthModel()
        userInfoModel = UserInfoModel()
        input = Input()
        output = Output()
    }
}

extension MonthViewModel {

    struct Input {}

    struct Output {}
}
