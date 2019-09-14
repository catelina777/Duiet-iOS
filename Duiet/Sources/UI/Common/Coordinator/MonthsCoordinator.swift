//
//  MonthsCoordinator.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/05.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class MonthsCoordinator: Coordinator {
    private let navigator: BaseNavigationController
    private let tabViewModel: TopTabBarViewModel

    init(navigator: BaseNavigationController,
         tabViewModel: TopTabBarViewModel) {
        self.navigator = navigator
        self.tabViewModel = tabViewModel
    }

    func start() {
        let model = MonthsModel(repository: MonthsRepository.shared)
        let vc = TopMonthsViewController(viewModel: .init(coordinator: self, monthsModel: model),
                                         tabViewModel: tabViewModel)
        navigator.pushViewController(vc, animated: false)
    }
}
