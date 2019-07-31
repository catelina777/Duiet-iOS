//
//  TopTabBarViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/30.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

final class TopTabBarViewModel {
    let input: Input
    let output: Output

    private let disposeBag = DisposeBag()

    init() {
        let _itemDidSelect = PublishRelay<Day>()
        let _showDays = PublishRelay<Month>()
        input = Input(itemDidSelect: _itemDidSelect.asObserver(),
                      showDays: _showDays.asObserver())
        output = Output(showDetailDay: _itemDidSelect.asObservable(),
                        showDays: _showDays.asObservable())
    }
}

extension TopTabBarViewModel {
    struct Input {
        let itemDidSelect: AnyObserver<Day>
        let showDays: AnyObserver<Month>
    }

    struct Output {
        let showDetailDay: Observable<Day>
        let showDays: Observable<Month>
    }
}
