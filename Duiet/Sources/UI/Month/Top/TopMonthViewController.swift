//
//  TopMonthViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/04.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class TopMonthViewController: MonthViewController {

    private let tabViewModel: TopTabBarViewModel

    init(viewModel: MonthViewModel,
         tabViewModel: TopTabBarViewModel) {
        self.tabViewModel = tabViewModel
        super.init(viewModel: viewModel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.output.showDetailDay
            .bind(to: tabViewModel.input.itemDidSelect)
            .disposed(by: disposeBag)

        tabViewModel.output.showDays
            .bind(to: viewModel.input.selectedMonth)
            .disposed(by: disposeBag)
    }
}
