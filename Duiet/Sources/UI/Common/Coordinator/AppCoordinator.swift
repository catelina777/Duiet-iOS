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

    private var walkthroughCoordinator: WalkthrouthCoordinator!
    private let walkthroughNavigator: UINavigationController
    private var topTabBarCoordinator: TopTabBarCoordinator!
    private let topTabBarNavigator: UINavigationController

    init(window: UIWindow) {
        self.window = window
        self.topTabBarNavigator = UINavigationController()
        self.walkthroughNavigator = UINavigationController()

        let dayNC = get(type: .day)
        let monthNC = get(type: .month)
        let yearNC = get(type: .year)
        let settingNC = get(type: .setting)

        let viewModel = TopTabBarViewModel()

        navigatorInit(type: .day, navigationController: dayNC, tabViewModel: viewModel)
        navigatorInit(type: .month, navigationController: monthNC, tabViewModel: viewModel)
        navigatorInit(type: .year, navigationController: yearNC, tabViewModel: viewModel)
        navigatorInit(type: .setting, navigationController: settingNC, tabViewModel: viewModel)

        self.topTabBarCoordinator = TopTabBarCoordinator(navigator: topTabBarNavigator,
                                                         viewModel: viewModel,
                                                         navigationControllers: [dayNC, monthNC, yearNC, settingNC])

        self.walkthroughCoordinator = WalkthrouthCoordinator(navigator: walkthroughNavigator,
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

    private func get(type: SceneType) -> UINavigationController {
        let nc = UINavigationController()
        nc.tabBarItem = type.tabBarItem
        return nc
    }

    private func navigatorInit(type: SceneType,
                               navigationController: UINavigationController,
                               tabViewModel: TopTabBarViewModel) {
        let coordinator: Coordinator
        switch type {
        case .day:
            coordinator = TodayCoordinator(navigator: navigationController, tabViewModel: tabViewModel)
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
