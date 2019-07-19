//
//  SettingViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/08.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingViewController: BaseTableViewController, NavigationBarCustomizable {

    private let viewModel: SettingViewModel
    private let dataSource: SettingViewDataSource

    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        dataSource = SettingViewDataSource(viewModel: viewModel)
        super.init(nibName: SettingViewController.className, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(with: SceneType.setting.title)
        dataSource.configure(with: tableView)
    }
}
