//
//  SettingViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/08.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift

final class SettingViewModel {

    private let coordinator: SettingCoordinator

    init(coordinator: SettingCoordinator) {
        self.coordinator = coordinator
    }
}

extension SettingViewModel {

    struct Input {}

    struct Output {}
}
