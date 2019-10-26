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
    private let segmentedViewModel: SegmentedControlViewModel
    private var viewController: HistoriesViewController!

    init(navigator: BaseNavigationController,
         segmentedViewModel: SegmentedControlViewModel) {
        self.navigator = navigator
        self.segmentedViewModel = segmentedViewModel
        let todayNC = BaseNavigationController()
        let daysNC = BaseNavigationController()
        let monthsNC = BaseNavigationController()

        navigationInit(type: .today, navigationController: todayNC, segmentedViewModel: segmentedViewModel)
        navigationInit(type: .days, navigationController: daysNC, segmentedViewModel: segmentedViewModel)
        navigationInit(type: .months, navigationController: monthsNC, segmentedViewModel: segmentedViewModel)
        let vm = HistoriesViewModel()
        viewController = HistoriesViewController(viewModel: vm,
                                                 segmentedViewModel: segmentedViewModel,
                                                 navigationControllers: [todayNC, daysNC, monthsNC])
    }

    func start() {
        navigator.pushViewController(viewController, animated: false)
    }

    private func navigationInit(type: HistoryType,
                                navigationController: BaseNavigationController,
                                segmentedViewModel: SegmentedControlViewModel) {
        let coordinator: Coordinator
        switch type {
        case .today:
            coordinator = TodayCoordinator(navigator: navigationController, segmentedViewModel: segmentedViewModel)

        case .days:
            coordinator = DaysCoordinator(navigator: navigationController, segmentedViewModel: segmentedViewModel)

        case .months:
            coordinator = MonthsCoordinator(navigator: navigationController, segmentedViewModel: segmentedViewModel)
        }
        coordinator.start()
    }
}
