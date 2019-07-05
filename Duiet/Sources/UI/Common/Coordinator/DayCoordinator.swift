//
//  DayCoordinator.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/05.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class DayCoordinator: Coordinator {

    private let navigator: UINavigationController
    private let tabViewModel: TopTabBarViewModel

    init(navigator: UINavigationController,
         tabViewModel: TopTabBarViewModel) {
        self.navigator = navigator
        self.tabViewModel = tabViewModel
    }

    func start() {
        let repository = DayRepository()
        let model = DayModel(repository: repository)
        let topDayVC = TopDayViewController(viewModel: .init(coordinator: self, model: model),
                                            tabViewModel: tabViewModel)
        navigator.pushViewController(topDayVC, animated: false)
    }
}
