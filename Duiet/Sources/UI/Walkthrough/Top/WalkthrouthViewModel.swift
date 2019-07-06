//
//  WalkthrouthViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/06.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class WalkthroughViewModel {

    let input: Input
    let output: Output

    private let coordinator: WalkthrouthCoordinator
    private let disposeBag = DisposeBag()

    init(coordinator: WalkthrouthCoordinator) {
        self.coordinator = coordinator

        let _pushFillInformation = PublishRelay<Void>()
        input = Input(pushFillInformation: _pushFillInformation.asObserver())
        output = Output()

        // MARK - transition
        _pushFillInformation
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: coordinator.showFillInformation)
            .disposed(by: disposeBag)
    }
}

extension WalkthroughViewModel {

    struct Input {
        let pushFillInformation: AnyObserver<Void>
    }
    struct Output {}
}
