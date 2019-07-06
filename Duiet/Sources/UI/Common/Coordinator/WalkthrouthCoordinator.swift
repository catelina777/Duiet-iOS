//
//  WalkthrouthCoordinator.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/05.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class WalkthrouthCoordinator: Coordinator {

    private let topTabBarCoordinator: TopTabBarCoordinator
    private let navigator: UINavigationController

    init(navigator: UINavigationController, topTabBarCoordinator: TopTabBarCoordinator) {
        self.navigator = navigator
        self.topTabBarCoordinator = topTabBarCoordinator
    }

    func start() {
        let vc = WalkthroughViewController(viewModel: .init(coordinator: self))
        navigator.pushViewController(vc, animated: false)
    }

    func showFillInformation() {
        let vc = FillInformationViewController(viewModel: .init(coordinator: self))
        navigator.pushViewController(vc, animated: true)
    }

    func showTop() {
        let vc = topTabBarCoordinator.controller
        navigator.present(vc, animated: true, completion: nil)
    }
}
