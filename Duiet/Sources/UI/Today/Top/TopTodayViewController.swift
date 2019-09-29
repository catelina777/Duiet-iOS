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

    init(viewModel: TodayViewModelProtocol,
         tabViewModel: TopTabBarViewModel) {
        self.tabViewModel = tabViewModel
        super.init(viewModel: viewModel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = R.string.localizable.today()

        tabViewModel.output.showDetailDay
            .bind(to: viewModel.input.showDetailDay)
            .disposed(by: disposeBag)

        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.input.willLoadData)
            .disposed(by: disposeBag)

        viewModel.output.didLoadData
            .map { false }
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
}
