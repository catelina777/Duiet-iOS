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
    private let viewModel: TopTabBarViewModel
    private let viewControllers: [UIViewController]

    init(navigator: UINavigationController, viewModel: TopTabBarViewModel, viewControllers: [UIViewController]) {
        self.navigator = navigator
        self.viewModel = viewModel
        self.viewControllers = viewControllers
    }

    func start() {
        let vc = TopTabBarController(viewModel: viewModel)
        vc.viewControllers = viewControllers
        navigator.pushViewController(vc, animated: false)
    }
}
