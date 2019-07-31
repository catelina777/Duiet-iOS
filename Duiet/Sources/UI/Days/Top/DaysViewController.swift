//
//  DaysViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/16.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

class DaysViewController: BaseCollectionViewController, NavigationBarCustomizable {
    let viewModel: DaysViewModel
    private let dataSource: DaysViewDataSource

    init(viewModel: DaysViewModel) {
        self.viewModel = viewModel
        self.dataSource = DaysViewDataSource(viewModel: viewModel)
        super.init(nibName: DaysViewController.className, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(with: viewModel.title)
        dataSource.configure(with: collectionView)
    }
}
