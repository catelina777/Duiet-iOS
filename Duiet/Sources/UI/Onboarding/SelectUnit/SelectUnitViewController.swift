//
//  SelectUnitViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/10/14.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class SelectUnitViewController: BaseTableViewController {
    private let viewModel: SelectUnitViewModelProtocol
    private let dataSource: SelectUnitViewDataSource

    @IBOutlet private weak var nextButton: ValidatableRoundedButton! {
        didSet {
            nextButton.setTitle(R.string.localizable.nextButton(), for: .normal)
        }
    }

    init(viewModel: SelectUnitViewModelProtocol) {
        self.viewModel = viewModel
        dataSource = SelectUnitViewDataSource(viewModel: viewModel)
        super.init(nibName: SelectUnitViewController.className, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Select Unit"
        navigationController?.navigationBar.prefersLargeTitles = true
        dataSource.configure(with: tableView)

        bindNextButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension SelectUnitViewController {
    private func bindNextButton() {
        nextButton.rx.tap
            .bind(to: viewModel.input.didTapNextButton)
            .disposed(by: disposeBag)

        viewModel.output.isValidateComplete
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
