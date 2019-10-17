//
//  SelectUnitViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/10/14.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class SelectUnitViewController: BaseTableViewController {
    private let viewModel: SelectUnitViewModelProtocol
    private let dataSource: SelectUnitViewDataSource

    init(viewModel: SelectUnitViewModelProtocol) {
        self.viewModel = viewModel
        dataSource = SelectUnitViewDataSource(viewModel: viewModel)
        super.init(nibName: SelectUnitViewController.className, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Select Unit"
        navigationController?.navigationBar.prefersLargeTitles = true
        dataSource.configure(with: tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
