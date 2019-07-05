//
//  YearViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/09.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class YearViewModel {

    private let yearModel: YearModel
    private let coordinator: YearCoordinator
    private let disposeBag = DisposeBag()

    var months: [Month] {
        return yearModel.months.value
    }

    init(coordinator: YearCoordinator) {
        self.coordinator = coordinator
        yearModel = YearModel.shared
    }
}

extension YearViewModel {

    struct Input {}

    struct Output {}
}
