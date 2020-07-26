//
//  MonthSummaryViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/09.
//  Copyright © 2019 Duiet. All rights reserved.
//

import Foundation

protocol MonthSummaryViewModelInput {}

protocol MonthSummaryViewModelOutput {}

protocol MonthSummaryViewModelData {
    var progress: [ProgressType?] { get }
    var userProfile: UserProfile { get }
}

protocol MonthSummaryViewModelProtocol {
    var input: MonthSummaryViewModelInput { get }
    var output: MonthSummaryViewModelOutput { get }
    var data: MonthSummaryViewModelData { get }
}

final class MonthSummaryViewModel: MonthSummaryViewModelProtocol, MonthSummaryViewModelData {
    let input: MonthSummaryViewModelInput
    let output: MonthSummaryViewModelOutput
    var data: MonthSummaryViewModelData { self }

    let progress: [ProgressType?]
    let userProfile: UserProfile

    init(month: Month,
         userProfileModel: UserProfileModelProtocol = UserProfileModel.shared) {
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

        let compensationProgress: [ProgressType?] = .init(repeating: nil, count: compensationNum)

        let daysNum = lastDate.day()
        var days: [DayEntity?] = .init(repeating: nil, count: daysNum)
        month.days.forEach {
            days[$0.createdAt.index()] = $0
        }

        let tdee = userProfileModel.state.userProfileValue.TDEE
        let progress: [ProgressType?] = days.map { dayEntity -> ProgressType in
            if let dayEntity = dayEntity {
                let day = Day(entity: dayEntity)
                if day.totalCalorie < tdee {
                    return ProgressType.less
                } else {
                    return ProgressType.exceed
                }
            }
            return ProgressType.none
        }

        self.progress = compensationProgress + progress
        userProfile = userProfileModel.state.userProfileValue
        input = Input()
        output = Output()
    }
}

extension MonthSummaryViewModel {
    struct Input: MonthSummaryViewModelInput {}

    struct Output: MonthSummaryViewModelOutput {}
}
