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

    private var walkthroughCoordinator: OnboardingCoordinator!
    private let walkthroughNavigator: BaseNavigationController
    private var topTabBarCoordinator: TopTabBarCoordinator!
    private let topTabBarNavigator: BaseNavigationController

    init(window: UIWindow) {
        self.window = window
        topTabBarNavigator = BaseNavigationController()
        walkthroughNavigator = BaseNavigationController()

        let dayNC = get(type: .today)
        let monthNC = get(type: .days)
        let yearNC = get(type: .months)
        let settingNC = get(type: .setting)

        let viewModel = TopTabBarViewModel()

        navigatorInit(type: .today, navigationController: dayNC, tabViewModel: viewModel)
        navigatorInit(type: .days, navigationController: monthNC, tabViewModel: viewModel)
        navigatorInit(type: .months, navigationController: yearNC, tabViewModel: viewModel)
        navigatorInit(type: .setting, navigationController: settingNC, tabViewModel: viewModel)

        topTabBarCoordinator = TopTabBarCoordinator(navigator: topTabBarNavigator,
                                                    viewModel: viewModel,
                                                    navigationControllers: [dayNC, monthNC, yearNC, settingNC])

        walkthroughCoordinator = OnboardingCoordinator(navigator: walkthroughNavigator,
                                                        topTabBarCoordinator: topTabBarCoordinator)
    }

    func initialStart() {
        window.rootViewController = walkthroughNavigator
        walkthroughCoordinator.start()
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
        case .today:
            coordinator = TodayCoordinator(navigator: navigationController, tabViewModel: tabViewModel)

        case .days:
            coordinator = DaysCoordinator(navigator: navigationController, tabViewModel: tabViewModel)

        case .months:
            coordinator = MonthsCoordinator(navigator: navigationController, tabViewModel: tabViewModel)

        case .setting:
            coordinator = SettingCoordinator(navigator: navigationController, tabViewModel: tabViewModel)
        }
        coordinator.start()
    }
}
