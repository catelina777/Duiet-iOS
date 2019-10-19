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

protocol SettingViewModelInput {
    var itemDidSelect: AnyObserver<SettingType> { get }
}

protocol SettingViewModelOutput {}

protocol SettingViewModelProtocol {
    var input: SettingViewModelInput { get }
    var output: SettingViewModelOutput { get }
}

final class SettingViewModel: SettingViewModelProtocol {
    let input: SettingViewModelInput
    let output: SettingViewModelOutput

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

                case .editUnit:
                    coordinator.showSelectUnit()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension SettingViewModel {
    struct Input: SettingViewModelInput {
        let itemDidSelect: AnyObserver<SettingType>
    }

    struct Output: SettingViewModelOutput {}
}
