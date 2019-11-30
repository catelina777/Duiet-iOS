//
//  ManageDataViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/23.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxCocoa
import UIKit

final class ManageDataViewController: BaseCollectionViewController {
    private let viewModel: ManageDataViewModelProtocol
    private let dataSource: ManageDataViewDataSource

    init(viewModel: ManageDataViewModelProtocol) {
        self.viewModel = viewModel
        self.dataSource = ManageDataViewDataSource(viewModel: viewModel)
        super.init(nibName: ManageDataViewController.className, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = SettingType.manageData.contentText
        navigationController?.navigationBar.prefersLargeTitles = true
        dataSource.configure(with: collectionView)
    }
}
