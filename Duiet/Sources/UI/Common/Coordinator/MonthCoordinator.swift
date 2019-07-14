//
//  MonthCoordinator.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/05.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class MonthCoordinator: Coordinator {

    private let navigator: UINavigationController
    private let tabViewModel: TopTabBarViewModel

    init(navigator: UINavigationController,
         tabViewModel: TopTabBarViewModel) {
        self.navigator = navigator
        self.tabViewModel = tabViewModel
    }

    func start() {
        let model = MonthModel(repository: MonthRepository.shared)
        let vc = TopMonthViewController(viewModel: .init(coordinator: self, model: model),
                                        tabViewModel: tabViewModel)
        navigator.pushViewController(vc, animated: false)
    }

    func show(month: Month) {
        let model = MonthModel(month: month, repository: MonthRepository.shared)
        let vc = TopMonthViewController(viewModel: .init(coordinator: self, model: model),
                                        tabViewModel: tabViewModel)
        navigator.pushViewController(vc, animated: false)
    }
}
