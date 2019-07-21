//
//  SettingViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/08.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class SettingViewModel {

    let input: Input
    let output: Output

    private let coordinator: SettingCoordinator
    private let disposeBag = DisposeBag()

    init(coordinator: SettingCoordinator) {
        self.coordinator = coordinator

        let _itemDidSelect = PublishRelay<SettingType>()
        input = Input(itemDidSelect: _itemDidSelect.asObserver())

        output = Output()

        _itemDidSelect
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] settingType in
                guard let me = self else { return }
                switch settingType {
                case .editInfo:
                    print("edit info")
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
