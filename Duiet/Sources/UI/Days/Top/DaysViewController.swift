//
//  DaysViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/16.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

class DaysViewController: BaseCollectionViewController {
    let viewModel: DaysViewModelProtocol
    private let dataSource: DaysViewDataSource

    init(viewModel: DaysViewModelProtocol) {
        self.viewModel = viewModel
        self.dataSource = DaysViewDataSource(viewModel: viewModel)
        super.init(nibName: DaysViewController.className, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.state.title
        navigationController?.navigationBar.prefersLargeTitles = true
        dataSource.configure(with: collectionView)

        bindRefreshThenReloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
}
