//
//  MonthViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/16.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

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

    var title: String {
        return monthModel.title
    }

    init(coordinator: MonthCoordinator,
         model: MonthModelProtocol) {
        self.coordinator = coordinator
        self.monthModel = model
        self.userInfoModel = UserInfoModel.shared

        let _selectedDay = PublishRelay<Day>()
        let _selectedMonth = PublishRelay<Month>()
        input = Input(selectedDay: _selectedDay.asObserver(),
                      selectedMonth: _selectedMonth.asObserver())
        output = Output(showDetailDay: _selectedDay.asObservable())

        _selectedMonth
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { month in
                coordinator.show(month: month)
            })
            .disposed(by: disposeBag)
    }
}

extension MonthViewModel {

    struct Input {
        let selectedDay: AnyObserver<Day>
        let selectedMonth: AnyObserver<Month>
    }

    struct Output {
        let showDetailDay: Observable<Day>
    }
}
