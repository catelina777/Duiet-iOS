//
//  TodayViewController.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/23.
//  Copyright © 2019 duiet. All rights reserved.
//

import Hero
import RealmSwift
import RxCocoa
import RxRealm
import RxSwift
import UIKit

class TodayViewController: BaseCollectionViewController, NavigationBarCustomizable {
    let viewModel: TodayViewModel
    private let dataSource: TodayViewDataSource

    init(viewModel: TodayViewModel) {
        self.viewModel = viewModel
        self.dataSource = TodayViewDataSource(viewModel: viewModel)
        super.init(nibName: TodayViewController.className, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(with: viewModel.title)
        dataSource.configure(with: collectionView)

        rx.methodInvoked(#selector(self.viewDidAppear(_:)))
            .map { _ in }
            .bind(to: viewModel.input.viewDidAppear)
            .disposed(by: disposeBag)

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItem = addButton
        addButton.rx.tap
            .map { self }
            .bind(to: viewModel.input.addButtonTap)
            .disposed(by: disposeBag)

        viewModel.output.changeData
            .bind(to: applyChange)
            .disposed(by: disposeBag)
    }

    private var applyChange: Binder<RealmChangeset?> {
        return Binder(self) { me, changes in
            if let changes = changes {
                let inserted = changes.inserted.map { IndexPath(row: $0 + 1, section: 0) }
                let updated = changes.updated.map { IndexPath(row: $0 + 1, section: 0) }
                let deleted = changes.deleted.map { IndexPath(row: $0 + 1, section: 0) }
                me.collectionView.insertItems(at: inserted)
                me.collectionView.reloadItems(at: updated)
                me.collectionView.deleteItems(at: deleted)
            } else {
                me.collectionView.reloadData()
            }
        }
    }
}
