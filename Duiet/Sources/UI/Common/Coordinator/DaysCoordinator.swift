//
//  DaysCoordinator.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/05.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class DaysCoordinator: Coordinator {
    private let navigator: UINavigationController
    private let tabViewModel: TopTabBarViewModel

    init(navigator: UINavigationController,
         tabViewModel: TopTabBarViewModel) {
        self.navigator = navigator
        self.tabViewModel = tabViewModel
    }

    func start() {
        let model = DaysModel()
        let vc = TopDaysViewController(viewModel: .init(coordinator: self,
                                                        userInfoModel: UserInfoModel.shared,
                                                        daysModel: model),
                                        tabViewModel: tabViewModel)
        navigator.pushViewController(vc, animated: false)
    }

    func show(month: Month) {
        let model = DaysModel(month: month)
        let vc = TopDaysViewController(viewModel: .init(coordinator: self,
                                                        userInfoModel: UserInfoModel.shared,
                                                        daysModel: model),
                                        tabViewModel: tabViewModel)
        navigator.pushViewController(vc, animated: true)
    }
}
