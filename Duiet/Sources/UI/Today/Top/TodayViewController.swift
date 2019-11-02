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
        let button = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle.fill"), style: .plain, target: nil, action: nil)
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
        button.tintColor = R.color.componentMain()
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

        configureButtons()
        bindViewDidAppear()
        bindAddButton()
        bindEditButton()
        bindTrashButton()
        bindDoneButton()
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

    private func configureButtons() {
        navigationItem.rightBarButtonItems = [addButton, editButton]
    }

    private func bindAddButton() {
        addButton.rx.tap
            .map { self }
            .bind(to: viewModel.input.didTapAddButton)
            .disposed(by: disposeBag)
    }

    private func bindEditButton() {
        editButton.rx.tap
            .bind(to: didTapEditButton)
            .disposed(by: disposeBag)
    }

    private func bindTrashButton() {
        trashButton.rx.tap
            .bind(to: didTapTrashButton)
            .disposed(by: disposeBag)

        viewModel.output.isEnableTrashButton
            .bind(to: isEnableTrashButton)
            .disposed(by: disposeBag)
    }

    private func bindDoneButton() {
        doneButton.rx.tap
            .bind(to: didTapDoneButton)
            .disposed(by: disposeBag)
    }

    var isEnableTrashButton: Binder<Bool> {
        Binder<Bool>(self) { me, isEnable in
            if isEnable {
                me.trashButton.isEnabled = false
                me.trashButton.tintColor = .systemGray
            } else {
                me.trashButton.isEnabled = true
                me.trashButton.tintColor = R.color.componentMain()
            }
        }
    }

    var didTapEditButton: Binder<Void> {
        Binder<Void>(self) { me, _ in
            me.navigationItem.rightBarButtonItems = [me.trashButton, me.doneButton]

            me.viewModel.input.isEditMode.on(.next(true))
        }
    }

    var didTapDoneButton: Binder<Void> {
        Binder<Void>(self) { me, _ in
            me.navigationItem.rightBarButtonItems = [me.addButton, me.editButton]

            me.viewModel.input.isEditMode.on(.next(false))
            me.viewModel.state.deletionTargetMeals.accept([])
        }
    }

    var didTapTrashButton: Binder<Void> {
        Binder<Void>(self) { me, _ in
            let title = "This content will be deleted form your device"
            let delete = "Delete content"
            let cancelTitle = "Cancel"
            let alertView = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: delete, style: .destructive) { _ in
                me.viewModel.input.didTapDeleteButton.on(.next(()))
                me.viewModel.state.deletionTargetMeals.accept([])
                me.collectionView.reloadData()
            }
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in }
            alertView.addAction(deleteAction)
            alertView.addAction(cancelAction)

            me.present(alertView, animated: true, completion: nil)
        }
    }
}
