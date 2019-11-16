//
//  MonthsViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/08.
//  Copyright © 2019 Duiet. All rights reserved.
//

import UIKit

class MonthsViewController: BaseCollectionViewController {
    let viewModel: MonthsViewModelProtocol
    private let dataSource: MonthsViewDataSource

    init(viewModel: MonthsViewModelProtocol) {
        self.viewModel = viewModel
        dataSource = MonthsViewDataSource(viewModel: viewModel)
        super.init(nibName: MonthsViewController.className, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = HistoryType.months.title
        navigationController?.navigationBar.prefersLargeTitles = true
        dataSource.configure(with: collectionView)

        bindRefreshThenReloadData()
        viewModel.output.reloadData
            .bind(to: reloadData)
            .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
}
