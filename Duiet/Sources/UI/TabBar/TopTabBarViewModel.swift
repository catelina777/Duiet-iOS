//
//  TopTabBarViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/30.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class TopTabBarViewModel {

    let input: Input
    let output: Output

    private let disposeBag = DisposeBag()

    init() {
        let _showDetailDay = PublishRelay<Date>()
        let _showDays = PublishRelay<Month>()
        input = Input(showDetailDay: _showDetailDay.asObserver(),
                      showDays: _showDays.asObserver())
        output = Output(showDetailDay: _showDetailDay.asObservable(),
                        showDays: _showDays.asObservable())

        _showDays
            .subscribe(onNext: {
                print("in tab view model")
                print($0.createdAt)
            })
            .disposed(by: disposeBag)
    }
}

extension TopTabBarViewModel {

    struct Input {
        let showDetailDay: AnyObserver<Date>
        let showDays: AnyObserver<Month>
    }

    struct Output {
        let showDetailDay: Observable<Date>
        let showDays: Observable<Month>
    }
}
