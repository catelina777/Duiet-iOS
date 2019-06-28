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

    let monthModel: MonthModel
    let userInfoModel: UserInfoModel

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
