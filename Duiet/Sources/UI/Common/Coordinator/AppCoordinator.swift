//
//  AppCoordinator.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/05.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class AppCoordinator {
    private let window: UIWindow

    private var onboardingCoordinator: OnboardingCoordinator!
    private let onboardingNavigator: BaseNavigationController
    private var topTabBarCoordinator: TopTabBarCoordinator!
    private let topTabBarNavigator: BaseNavigationController

    init(window: UIWindow) {
        self.window = window
        topTabBarNavigator = BaseNavigationController()
        onboardingNavigator = BaseNavigationController()

        let historiesNC = get(type: .histories)
        let settingNC = get(type: .setting)

        let viewModel = SegmentedControlViewModel()

        navigatorInit(type: .histories, navigationController: historiesNC, segmentedViewModel: viewModel)
        navigatorInit(type: .setting, navigationController: settingNC, segmentedViewModel: viewModel)

        topTabBarCoordinator = TopTabBarCoordinator(navigator: topTabBarNavigator,
                                                    navigationControllers: [historiesNC, settingNC])

        onboardingCoordinator = OnboardingCoordinator(navigator: onboardingNavigator,
                                                      topTabBarCoordinator: topTabBarCoordinator)
    }

    func initialStart() {
        window.rootViewController = onboardingNavigator
        onboardingCoordinator.start()
        window.makeKeyAndVisible()
    }

    func start() {
        window.rootViewController = topTabBarNavigator
        topTabBarCoordinator.start()
        window.makeKeyAndVisible()
    }

    private func get(type: SceneType) -> BaseNavigationController {
        let nc = BaseNavigationController()
        nc.tabBarItem = type.tabBarItem
        return nc
    }

    private func navigatorInit(type: SceneType,
                               navigationController: BaseNavigationController,
                               segmentedViewModel: SegmentedControlViewModel) {
        let coordinator: Coordinator
        switch type {
        case .histories:
            coordinator = HistoriesCoordinator(navigator: navigationController, segmentedViewModel: segmentedViewModel)

        case .setting:
            coordinator = SettingCoordinator(navigator: navigationController, segmentedViewModel: segmentedViewModel)
        }
        coordinator.start()
    }
}
