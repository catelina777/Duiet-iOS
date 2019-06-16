//
//  AllHistoryViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/08.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class AllHistoryViewController: BaseCollectionViewController, NavigationBarCustomizable {

    private let viewModel: AllHistoryViewModel
    private let dataSource: AllHistoryViewDataSource

    init() {
        self.viewModel = AllHistoryViewModel()
        self.dataSource = AllHistoryViewDataSource(viewModel: viewModel)
        super.init(nibName: AllHistoryViewController.className, bundle: nil)
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
