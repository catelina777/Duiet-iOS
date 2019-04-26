//
//  FillInformationViewDataSource.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift

class FillInformationViewDataSource: NSObject {

    private let viewModel: FillInformationViewModel

    init(viewModel: FillInformationViewModel) {
        self.viewModel = viewModel
    }

    func configure(with tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 140
        tableView.keyboardDismissMode = .onDrag
        tableView.register(R.nib.inputNumberViewCell)
        tableView.register(R.nib.inputGenderViewCell)
        tableView.register(R.nib.inputActivityLevelViewCell)
        tableView.register(R.nib.completeButtonViewCell)
    }
}

extension FillInformationViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowCounts
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.inputGenderViewCell,
                                                     for: indexPath)!
            cell.isMale
                .bind(to: viewModel.input.gender)
                .disposed(by: cell.disposeBag)
            cell.configure(with: .gender)
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.inputNumberViewCell,
                                                     for: indexPath)!
            cell.configure(with: viewModel, type: .height)
            return cell

        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.inputNumberViewCell,
                                                     for: indexPath)!
            cell.configure(with: viewModel, type: .weight)
            return cell

        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.inputActivityLevelViewCell,
                                                     for: indexPath)!
            cell.configure(with: .activityLevel)
            cell.configure(with: viewModel)
            return cell

        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.completeButtonViewCell,
                                                     for: indexPath)!

            viewModel.output.isValidateComplete
                .bind(to: cell.isComplete)
                .disposed(by: cell.disposeBag)

            cell.completeButton.rx.tap
                .bind(to: viewModel.input.completeButtonTap)
                .disposed(by: cell.disposeBag)
            return cell

        default:
            let cell = UITableViewCell()
            return cell
        }
    }
}

extension FillInformationViewDataSource: UITableViewDelegate {}
