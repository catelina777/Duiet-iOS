//
//  WalkthrouthViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/06.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxCocoa
import RxRelay
import RxSwift

final class WalkthroughViewModel {
    let input: Input
    let output: Output

    private let disposeBag = DisposeBag()

    init(coordinator: WalkthrouthCoordinator) {
        let _pushFillInformation = PublishRelay<Void>()
        input = Input(pushFillInformation: _pushFillInformation.asObserver())
        output = Output()

        // MARK: - Processing to transition
        _pushFillInformation
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: {
                coordinator.showFillInformation()
            })
            .disposed(by: disposeBag)
    }
}

extension WalkthroughViewModel {
    struct Input {
        let pushFillInformation: AnyObserver<Void>
    }
    struct Output {}
}