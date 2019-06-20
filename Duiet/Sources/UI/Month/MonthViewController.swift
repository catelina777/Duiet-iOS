//
//  MonthViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/16.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class MonthViewController: BaseCollectionViewController, NavigationBarCustomizable {

    private let viewModel: MonthViewModel
    private let dataSource: MonthViewDataSource

    init() {
        self.viewModel = MonthViewModel()
        self.dataSource = MonthViewDataSource(viewModel: viewModel)
        super.init(nibName: MonthViewController.className, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(with: SceneType.month.title)
    }
}
