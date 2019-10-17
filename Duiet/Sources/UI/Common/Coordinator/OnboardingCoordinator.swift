//
//  OnboardingCoordinator.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/05.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class OnboardingCoordinator: Coordinator {
    private let topTabBarCoordinator: TopTabBarCoordinator
    private let navigator: BaseNavigationController

    init(navigator: BaseNavigationController,
         topTabBarCoordinator: TopTabBarCoordinator) {
        self.navigator = navigator
        self.topTabBarCoordinator = topTabBarCoordinator
    }

    func start() {
        let vm = WalkthroughViewModel(coordinator: self)
        let vc = WalkthroughViewController(viewModel: vm)
        navigator.pushViewController(vc, animated: false)
    }

    func showSelectUnit() {
        let vm = SelectUnitViewModel(coordinator: self)
        let vc = SelectUnitViewController(viewModel: vm)
        navigator.pushViewController(vc, animated: true)
    }

    func showFillInformation() {
        let vm = FillInformationViewModel(coordinator: self)
        let vc = FillInformationViewController(viewModel: vm)
        navigator.pushViewController(vc, animated: true)
    }

    func showTop() {
        let vc = topTabBarCoordinator.controller
        vc.modalPresentationStyle = .fullScreen
        navigator.present(vc, animated: true, completion: nil)
    }
}
