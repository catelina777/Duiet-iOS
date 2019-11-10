//
//  DaysCoordinator.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/05.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class DaysCoordinator: Coordinator {
    private let navigator: BaseNavigationController
    private let segmentedViewModel: SegmentedControlViewModel

    init(navigator: BaseNavigationController,
         segmentedViewModel: SegmentedControlViewModel) {
        self.navigator = navigator
        self.segmentedViewModel = segmentedViewModel
    }

    func start() {
        let model = DaysModel()
        let vc = TopDaysViewController(viewModel: .init(coordinator: self,
                                                        userProfileModel: UserProfileModel.shared,
                                                        daysModel: model),
                                        segmentedViewModel: segmentedViewModel)
        navigator.pushViewController(vc, animated: false)
    }

    func show(month: Month) {
        let model = DaysModel(month: month)
        let vc = TopDaysViewController(viewModel: .init(coordinator: self,
                                                        userProfileModel: UserProfileModel.shared,
                                                        daysModel: model),
                                        segmentedViewModel: segmentedViewModel)
        navigator.pushViewController(vc, animated: false)
    }
}
