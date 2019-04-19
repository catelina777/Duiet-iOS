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
        return 5
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
            cell.textField.rx.text.orEmpty
                .map { Double($0) }
                .bind(to: viewModel.input.height)
                .disposed(by: cell.disposeBag)
            cell.configure(with: .height)
            return cell

        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.inputNumberViewCell,
                                                     for: indexPath)!
            cell.textField.rx.text.orEmpty
                .map { Double($0) }
                .bind(to: viewModel.input.weight)
                .disposed(by: cell.disposeBag)
            cell.configure(with: .weight)
            return cell

        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.inputActivityLevelViewCell,
                                                     for: indexPath)!
            cell.configure(with: .activityLevel)
            return cell

        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.completeButtonViewCell,
                                                     for: indexPath)!
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
}

extension FillInformationViewDataSource: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.input.selectedIndexPath.onNext(indexPath)
    }
}
