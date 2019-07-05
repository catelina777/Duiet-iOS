//
//  WalkthrouthCoordinator.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/05.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class WalkthrouthCoordinator: Coordinator {

    private let navigator: UINavigationController

    init(navigator: UINavigationController) {
        self.navigator = navigator
    }

    func start() {
        let vc = WalkthroughViewController(viewModel: .init(coordinator: self))
        navigator.pushViewController(vc, animated: false)
    }
}
