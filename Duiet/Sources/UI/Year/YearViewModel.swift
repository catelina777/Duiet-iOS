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

    let testProgress: [ProgressType]
    let yearModel: YearModel

    init() {
        let testArray: [Int] = .init(repeating: 0, count: 30)
        testProgress = testArray.map { _ in ProgressType.get(by: Int.random(in: 0..<3)) }

        yearModel = YearModel.shared
    }
}

extension YearViewModel {

    struct Input {}

    struct Output {}
}
