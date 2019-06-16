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

    init(progress: [ProgressType]) {
        self.progress = progress
        input = Input()
        output = Output()
    }
}

extension MonthSummaryViewModel {

    struct Input {}

    struct Output {}
}
