//
//  MonthsViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/08.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

class MonthsViewController: BaseCollectionViewController, NavigationBarCustomizable {

    let viewModel: MonthsViewModel
    private let dataSource: MonthsViewDataSource

    init(viewModel: MonthsViewModel) {
        self.viewModel = viewModel
        self.dataSource = MonthsViewDataSource(viewModel: viewModel)
        super.init(nibName: MonthsViewController.className, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.configure(with: collectionView)
        configureNavigationBar(with: SceneType.months.title)
    }
}