//
//  HistoriesCoordinator.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/10/22.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class HistoriesCoordinator: Coordinator {
    private let navigator: BaseNavigationController
    private let tabViewModel: TopTabBarViewModel
    private var viewController: HistoriesViewController!

    init(navigator: BaseNavigationController,
         tabViewModel: TopTabBarViewModel) {
        self.navigator = navigator
        self.tabViewModel = tabViewModel
        let todayNC = BaseNavigationController()
        let daysNC = BaseNavigationController()
        let monthsNC = BaseNavigationController()

        navigationInit(type: .today, navigationController: todayNC, tabViewModel: tabViewModel)
        navigationInit(type: .days, navigationController: daysNC, tabViewModel: tabViewModel)
        navigationInit(type: .months, navigationController: monthsNC, tabViewModel: tabViewModel)
        let vm = HistoriesViewModel()
        viewController = HistoriesViewController(viewModel: vm, navigationControllers: [todayNC, daysNC, monthsNC])
    }

    func start() {
        navigator.pushViewController(viewController, animated: false)
    }

    private func navigationInit(type: HistoryType,
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
        }
        coordinator.start()
    }
}
