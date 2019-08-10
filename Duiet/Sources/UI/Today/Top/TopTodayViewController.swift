//
//  TopTodayViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/04.
//  Copyright © 2019 Duiet. All rights reserved.
//

import UIKit

final class TopTodayViewController: TodayViewController {
    private let tabViewModel: TopTabBarViewModel

    init(viewModel: TodayViewModel,
         tabViewModel: TopTabBarViewModel) {
        self.tabViewModel = tabViewModel
        super.init(viewModel: viewModel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        rx.methodInvoked(#selector(viewWillAppear(_:)))
            .map { _ in }
            .bind(to: viewModel.input.viewWillAppear)
            .disposed(by: disposeBag)

        tabViewModel.output.showDetailDay
            .bind(to: viewModel.input.showDetailDay)
            .disposed(by: disposeBag)
    }
}
