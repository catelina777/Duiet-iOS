//
//  TopTabBarCoordinator.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/05.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class TopTabBarCoordinator: Coordinator {
    private let navigator: UINavigationController
    let controller: TopTabBarController

    init(navigator: UINavigationController,
         viewModel: TopTabBarViewModel,
         navigationControllers: [UIViewController]) {
        self.navigator = navigator
        self.controller = TopTabBarController(viewModel: viewModel,
                                              navigationControllers: navigationControllers)
    }

    func start() {
        navigator.pushViewController(controller, animated: false)
    }
}
