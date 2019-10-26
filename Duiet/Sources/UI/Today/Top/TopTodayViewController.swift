//
//  TopTodayViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/04.
//  Copyright © 2019 Duiet. All rights reserved.
//

import UIKit

final class TopTodayViewController: TodayViewController {
    private let segmentedViewModel: SegmentedControlViewModel

    init(viewModel: TodayViewModelProtocol,
         segmentedViewModel: SegmentedControlViewModel) {
        self.segmentedViewModel = segmentedViewModel
        super.init(viewModel: viewModel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = HistoryType.today.title

        bindShowDetailDay()
    }
}

extension TopTodayViewController {
    private func bindShowDetailDay() {
        segmentedViewModel.output.showDetailDay
            .bind(to: viewModel.input.showDetailDay)
            .disposed(by: disposeBag)
    }
}
