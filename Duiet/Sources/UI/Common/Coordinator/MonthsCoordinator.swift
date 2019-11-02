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
    private let segmentedViewModel: SegmentedControlViewModel

    init(navigator: BaseNavigationController,
         segmentedViewModel: SegmentedControlViewModel) {
        self.navigator = navigator
        self.segmentedViewModel = segmentedViewModel
    }

    func start() {
        let model = MonthsModel(repository: MonthsRepository.shared)
        let vc = TopMonthsViewController(viewModel: .init(coordinator: self, monthsModel: model),
                                         segmentedViewModel: segmentedViewModel)
        navigator.pushViewController(vc, animated: false)
    }
}
