//
//  TopTabBarCoordinator.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/05.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class TopTabBarCoordinator: Coordinator {
    private let navigator: BaseNavigationController
    let controller: TopTabBarController

    init(navigator: BaseNavigationController,
         navigationControllers: [UIViewController]) {
        self.navigator = navigator
        controller = TopTabBarController(navigationControllers: navigationControllers)
    }

    func start() {
        navigator.pushViewController(controller, animated: false)
    }
}
