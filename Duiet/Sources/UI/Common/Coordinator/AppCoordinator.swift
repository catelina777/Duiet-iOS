//
//  AppCoordinator.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/05.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class AppCoordinator {

    static let shared = AppCoordinator()

    var walkthroughCoordinator: WalkthrouthCoordinator!
    var topTabBarCoordinator: TopTabBarCoordinator!

    func initialStart(in window: UIWindow) {
        let navigator = UINavigationController()
        walkthroughCoordinator = WalkthrouthCoordinator(navigator: navigator)
        window.rootViewController = navigator
        walkthroughCoordinator.start()
        window.makeKeyAndVisible()
    }

    func start(in window: UIWindow) {
        let dayNC = get(type: .day)
        let monthNC = get(type: .month)
        let yearNC = get(type: .year)
        let settingNC = get(type: .setting)

        let viewModel = TopTabBarViewModel()

        navigatorInit(type: .day, navigationController: dayNC, tabViewModel: viewModel)
        navigatorInit(type: .month, navigationController: monthNC, tabViewModel: viewModel)
        navigatorInit(type: .year, navigationController: yearNC, tabViewModel: viewModel)
        navigatorInit(type: .setting, navigationController: settingNC, tabViewModel: viewModel)

        let navigator = UINavigationController()
        topTabBarCoordinator = TopTabBarCoordinator(navigator: navigator,
                                                    viewModel: viewModel,
                                                    viewControllers: [dayNC, monthNC, yearNC, settingNC])
        window.rootViewController = navigator
        topTabBarCoordinator.start()
        window.makeKeyAndVisible()
    }

    private func get(type: SceneType) -> UINavigationController {
        let nc = UINavigationController()
        nc.tabBarItem = type.tabBarItem
        return nc
    }

    private func navigatorInit(type: SceneType, navigationController: UINavigationController, tabViewModel: TopTabBarViewModel) {
        let coordinator: Coordinator
        switch type {
        case .day:
            coordinator = DayCoordinator(navigator: navigationController, tabViewModel: tabViewModel)
        case .month:
            coordinator = MonthCoordinator(navigator: navigationController, tabViewModel: tabViewModel)
        case .setting:
            coordinator = SettingCoordinator(navigator: navigationController, tabViewModel: tabViewModel)
        case .year:
            coordinator = YearCoordinator(navigator: navigationController, tabViewModel: tabViewModel)
        }
        coordinator.start()
    }
}
