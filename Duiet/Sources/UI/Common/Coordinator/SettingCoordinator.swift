//
//  SettingCoordinator.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/05.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class SettingCoordinator: Coordinator {

    private let navigator: UINavigationController
    private let tabViewModel: TopTabBarViewModel

    init(navigator: UINavigationController,
         tabViewModel: TopTabBarViewModel) {
        self.navigator = navigator
        self.tabViewModel = tabViewModel
    }

    func start() {
        let vc = SettingViewController(viewModel: .init(coordinator: self))
        navigator.pushViewController(vc, animated: false)
    }

    func showFillInformation() {
        let vc = FillInformationViewController(viewModel: .init(coordinator: self))
        navigator.pushViewController(vc, animated: true)
    }
}
