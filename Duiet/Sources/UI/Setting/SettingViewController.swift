//
//  SettingViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/08.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class SettingViewController: BaseCollectionViewController {
    private let viewModel: SettingViewModelProtocol
    private let dataSource: SettingViewDataSource

    init(viewModel: SettingViewModelProtocol) {
        self.viewModel = viewModel
        dataSource = SettingViewDataSource(viewModel: viewModel)
        super.init(nibName: SettingViewController.className, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = SceneType.setting.title
        dataSource.configure(with: collectionView)
    }
}
