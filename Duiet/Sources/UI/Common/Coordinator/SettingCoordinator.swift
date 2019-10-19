//
//  SettingCoordinator.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/05.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class SettingCoordinator: Coordinator {
    private let navigator: BaseNavigationController
    private let tabViewModel: TopTabBarViewModel

    init(navigator: BaseNavigationController,
         tabViewModel: TopTabBarViewModel) {
        self.navigator = navigator
        self.tabViewModel = tabViewModel
    }

    func start() {
        let vm = SettingViewModel(coordinator: self)
        let vc = SettingViewController(viewModel: vm)
        navigator.pushViewController(vc, animated: false)
    }

    func showFillInformation() {
        let vm = FillInformationViewModel(coordinator: self)
        let vc = FillInformationViewController(viewModel: vm)
        navigator.pushViewController(vc, animated: true)
    }

    func showSelectUnit() {
        let vm = SelectUnitViewModel(coordinator: self)
        let vc = SelectUnitViewController(viewModel: vm)
        navigator.pushViewController(vc, animated: true)
    }

    func pop() {
        navigator.popViewController(animated: true)
    }
}
