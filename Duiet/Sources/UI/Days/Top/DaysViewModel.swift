//
//  DaysViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/16.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

final class DaysViewModel {
    let input: Input
    let output: Output

    private let daysModel: DaysModelProtocol
    private let userInfoModel: UserInfoModelProtocol
    private let coordinator: DaysCoordinator
    private let disposeBag = DisposeBag()

    var userInfo: UserInfo {
        return userInfoModel.userInfo.value
    }

    var days: [Day] {
        return daysModel.days.value
    }

    var title: String {
        return daysModel.title
    }

    init(coordinator: DaysCoordinator,
         userInfoModel: UserInfoModelProtocol,
         daysModel: DaysModelProtocol) {
        self.coordinator = coordinator
        self.daysModel = daysModel
        self.userInfoModel = userInfoModel

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

extension DaysViewModel {
    struct Input {
        let selectedDay: AnyObserver<Day>
        let selectedMonth: AnyObserver<Month>
    }

    struct Output {
        let showDetailDay: Observable<Day>
    }
}
