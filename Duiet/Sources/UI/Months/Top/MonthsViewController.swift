//
//  MonthsViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/08.
//  Copyright © 2019 Duiet. All rights reserved.
//

import UIKit

class MonthsViewController: BaseCollectionViewController, NavigationBarCustomizable {
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
        dataSource.configure(with: collectionView)
        configureNavigationBar(with: SceneType.months.title,
                               isLargeTitles: true)
    }
}
