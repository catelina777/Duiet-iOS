//
//  MonthViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/16.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

final class MonthViewModel {

    let input: Input
    let output: Output

    init() {
        input = Input()
        output = Output()
    }
}

extension MonthViewModel {

    struct Input {}

    struct Output {}
}
