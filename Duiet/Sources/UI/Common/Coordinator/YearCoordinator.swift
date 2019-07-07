//
//  YearCoordinator.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/05.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class YearCoordinator: Coordinator {

    private let navigator: UINavigationController
    private let tabViewModel: TopTabBarViewModel

    init(navigator: UINavigationController,
         tabViewModel: TopTabBarViewModel) {
        self.navigator = navigator
        self.tabViewModel = tabViewModel
    }

    func start() {
        let vc = TopYearViewController(viewModel: .init(coordinator: self),
                                       tabViewModel: tabViewModel)
        navigator.pushViewController(vc, animated: false)
    }
}
