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
    private let addButton: UIBarButtonItem! = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: nil, action: nil)
        button.tintColor = R.color.componentMain()
        return button
    }()

    private let editButton: UIBarButtonItem! = {
        let button = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: nil)
        button.tintColor = R.color.componentMain()
        return button
    }()

    private let doneButton: UIBarButtonItem! = {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        button.tintColor = R.color.componentMain()
        return button
    }()

    private let trashButton: UIBarButtonItem! = {
        let button = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: nil, action: nil)
        return button
    }()

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

        bindViewDidAppear()
        bindAddButton()
        bindRefreshThenReloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
}

extension TodayViewController {
    private func bindViewDidAppear() {
        rx.methodInvoked(#selector(viewDidAppear(_:)))
            .map { _ in }
            .bind(to: viewModel.input.viewDidAppear)
            .disposed(by: disposeBag)
    }

    private func bindAddButton() {
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = editButton
        addButton.rx.tap
            .map { self }
            .bind(to: viewModel.input.addButtonTap)
            .disposed(by: disposeBag)

        editButton.rx.tap
            .bind(to: didTapEditButton)
            .disposed(by: disposeBag)

        doneButton.rx.tap
            .bind(to: didTapDoneButton)
            .disposed(by: disposeBag)
    }

    var didTapEditButton: Binder<Void> {
        Binder<Void>(self) { me, _ in
            me.navigationItem.leftBarButtonItem = me.doneButton

            me.trashButton.isEnabled = false
            me.trashButton.tintColor = .systemGray
            me.navigationItem.rightBarButtonItem = me.trashButton
        }
    }

    var didTapDoneButton: Binder<Void> {
        Binder<Void>(self) { me, _ in
            me.navigationItem.leftBarButtonItem = me.editButton
            me.navigationItem.rightBarButtonItem = me.addButton
        }
    }
}
