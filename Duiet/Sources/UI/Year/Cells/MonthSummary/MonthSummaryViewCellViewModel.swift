//
//  MonthSummaryViewCellViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/09.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

final class MonthSummaryViewModel {

    let input: Input
    let output: Output

    let progress: [ProgressType]
    let userInfoModel: UserInfoModel

    init(month: Month) {
        // TODO: - Consider singletoning a UserInfoModel
        userInfoModel = UserInfoModel.shared

        /*
         1.Monthの日数個のnilが入った[Day?]を作成する
         2.Monthの持っているDaysを[Day?]の対応した要素に挿入し，
           Monthの日数個の要素が入った[Day?]を作成する
         3.[Day?]をMonthの日数個のカロリー合計値が入った[Double]に変換
         4.上記の[Days?]をmapし，Monthの日数個の要素が入った[ProgressType]を作成する4
        */

        let calendar = Calendar(identifier: .gregorian)

        var components = DateComponents()
        components.year = month.createdAt.year()
        components.month = month.createdAt.month()
        components.day = 1
        let firstDate = calendar.date(from: components)!

        components.year = month.createdAt.year()
        components.month = month.createdAt.month() + 1
        components.day = 0
        let lastDate = calendar.date(from: components)!

        let weekDay = calendar.component(.weekday, from: firstDate)
        let compensationNum = weekDay - 1
        let daysNum = lastDate.day() + compensationNum
        var days: [Day?] = .init(repeating: nil, count: daysNum)
        month.days.forEach { days[$0.createdAt.index() + compensationNum] = $0 }

        let tdee = userInfoModel.userInfo.value.TDEE
        let progress = days.map { day -> ProgressType in
            if let day = day {
                if day.totalCalorie < tdee {
                    return ProgressType.less
                } else {
                    return ProgressType.exceed
                }
            }
            return ProgressType.none
        }
        self.progress = progress

        input = Input()
        output = Output()
    }
}

extension MonthSummaryViewModel {

    struct Input {}

    struct Output {}
}
