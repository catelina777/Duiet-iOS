//
//  DayViewController.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/23.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm
import Hero

class DayViewController: BaseCollectionViewController, NavigationBarCustomizable {

    let viewModel: DayViewModel
    let dataSource: DayViewDataSource

    init(date: Date? = nil,
         viewModel: DayViewModel) {
        self.viewModel = viewModel
        self.dataSource = DayViewDataSource(viewModel: viewModel)
        super.init(nibName: DayViewController.className, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(with: SceneType.day.title)
        dataSource.configure(with: collectionView)

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItem = addButton

        rx.methodInvoked(#selector(self.viewDidAppear(_:)))
            .map { _ in }
            .bind(to: viewModel.input.viewDidAppear)
            .disposed(by: disposeBag)

        addButton.rx.tap
            .map { self }
            .bind(to: viewModel.input.addButtonTap)
            .disposed(by: disposeBag)

        viewModel.output.showDetail
            .bind(to: showDetail)
            .disposed(by: disposeBag)

        viewModel.output.editDetail
            .bind(to: editDetail)
            .disposed(by: disposeBag)

        viewModel.output.changeData
            .bind(to: applyChange)
            .disposed(by: disposeBag)
    }

    private var showDetail: Binder<(UIImage?, Meal)> {
        return Binder(self) { me, tuple in
            let vc = InputMealViewController(mealImage: tuple.0,
                                             meal: tuple.1,
                                             model: me.viewModel.dayModel)
            me.present(vc, animated: true, completion: nil)
            print("go to input meal view!!! ✌️✌️✌️")
        }
    }

    private var editDetail: Binder<(MealCardViewCell, Meal)> {
        return Binder(self) { me, tuple in
            let heroID = "meal\(tuple.1.date)"
            tuple.0.imageView.hero.id = heroID

            let vc = InputMealViewController(mealImage: tuple.0.imageView.image,
                                             meal: tuple.1,
                                             model: me.viewModel.dayModel)
            vc.hero.isEnabled = true
            vc.hero.modalAnimationType = .auto
            vc.headerView.hero.id = heroID
            me.present(vc, animated: true, completion: nil)
        }
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
