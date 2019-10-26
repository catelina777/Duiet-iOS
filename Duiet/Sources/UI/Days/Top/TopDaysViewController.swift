//
//  TopDaysViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/04.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class TopDaysViewController: DaysViewController {
    private let segmentedViewModel: SegmentedControlViewModel

    init(viewModel: DaysViewModel,
         segmentedViewModel: SegmentedControlViewModel) {
        self.segmentedViewModel = segmentedViewModel
        super.init(viewModel: viewModel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.output.showDetailDay
            .bind(to: segmentedViewModel.input.didSelectDayItem)
            .disposed(by: disposeBag)

        segmentedViewModel.output.showDays
            .bind(to: viewModel.input.selectedMonth)
            .disposed(by: disposeBag)
    }
}
