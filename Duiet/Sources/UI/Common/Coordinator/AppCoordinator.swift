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

        let viewModel = TopTabBarViewModel()

        navigatorInit(type: .histories, navigationController: historiesNC, tabViewModel: viewModel)
        navigatorInit(type: .setting, navigationController: settingNC, tabViewModel: viewModel)

        topTabBarCoordinator = TopTabBarCoordinator(navigator: topTabBarNavigator,
                                                    viewModel: viewModel,
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
                               tabViewModel: TopTabBarViewModel) {
        let coordinator: Coordinator
        switch type {
        case .histories:
            coordinator = HistoriesCoordinator(navigator: navigationController, tabViewModel: tabViewModel)

        case .setting:
            coordinator = SettingCoordinator(navigator: navigationController, tabViewModel: tabViewModel)
        }
        coordinator.start()
    }
}
