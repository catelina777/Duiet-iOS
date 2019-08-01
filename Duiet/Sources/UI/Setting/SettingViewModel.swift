//
//  SettingViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/08.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

final class SettingViewModel {
    let input: Input
    let output: Output

    private let disposeBag = DisposeBag()

    init(coordinator: SettingCoordinator) {
        let _itemDidSelect = PublishRelay<SettingType>()
        input = Input(itemDidSelect: _itemDidSelect.asObserver())

        output = Output()

        _itemDidSelect
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: {
                switch $0 {
                case .editInfo:
                    coordinator.showFillInformation()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension SettingViewModel {
    struct Input {
        let itemDidSelect: AnyObserver<SettingType>
    }

    struct Output {}
}
