//
//  WalkthrouthViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/06.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift

final class WalkthroughViewModel {

    private let coordinator: WalkthrouthCoordinator
    private let disposeBag = DisposeBag()

    init(coordinator: WalkthrouthCoordinator) {
        self.coordinator = coordinator
    }
}

extension WalkthroughViewModel {

    struct Input {}
    struct Output {}
}
