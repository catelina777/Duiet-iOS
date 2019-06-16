//
//  YearViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/08.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class YearViewController: BaseCollectionViewController, NavigationBarCustomizable {

    private let viewModel: YearViewModel
    private let dataSource: YearViewDataSource

    init() {
        self.viewModel = YearViewModel()
        self.dataSource = YearViewDataSource(viewModel: viewModel)
        super.init(nibName: YearViewController.className, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.configure(with: collectionView)
        configureNavigationBar(with: SceneType.year.title)
    }
}
