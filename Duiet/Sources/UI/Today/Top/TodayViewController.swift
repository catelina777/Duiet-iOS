//
//  TodayViewController.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/23.
//  Copyright © 2019 duiet. All rights reserved.
//

import RealmSwift
import RxCocoa
import RxRealm
import RxSwift
import UIKit

class TodayViewController: BaseCollectionViewController {
    let viewModel: TodayViewModelProtocol
    private let dataSource: TodayViewDataSource

    init(viewModel: TodayViewModelProtocol) {
        self.viewModel = viewModel
        self.dataSource = TodayViewDataSource(viewModel: viewModel)
        super.init(nibName: TodayViewController.className, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.state.title
        navigationController?.navigationBar.prefersLargeTitles = true
        dataSource.configure(with: collectionView)

        rx.methodInvoked(#selector(viewDidAppear(_:)))
            .map { _ in }
            .bind(to: viewModel.input.viewDidAppear)
            .disposed(by: disposeBag)

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItem = addButton
        addButton.rx.tap
            .map { self }
            .bind(to: viewModel.input.addButtonTap)
            .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
}
