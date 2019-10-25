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
         tabViewModel: TopTabBarViewModel,
         viewControllers: [UIViewController]) {
        self.navigator = navigator
        self.tabViewModel = tabViewModel
        let vm = HistoriesViewModel()
        viewController = HistoriesViewController(viewModel: vm,
                                                 viewControllers: viewControllers)
    }

    func start() {
        navigator.pushViewController(viewController, animated: false)
    }
}
