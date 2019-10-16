//
//  FillInformationViewDataSource.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxSwift
import UIKit

class FillInformationViewDataSource: NSObject {
    private let viewModel: FillInformationViewModelProtocol
    private let keyboardTrackViewModel: KeyboardTrackViewModel

    init(viewModel: FillInformationViewModelProtocol,
         keyboardTrackViewModel: KeyboardTrackViewModel) {
        self.viewModel = viewModel
        self.keyboardTrackViewModel = keyboardTrackViewModel
    }

    func configure(with tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 140
        tableView.keyboardDismissMode = .onDrag
        tableView.register(R.nib.showTDEEViewCell)
        tableView.register(R.nib.inputNumberViewCell)
        tableView.register(R.nib.inputGenderViewCell)
        tableView.register(R.nib.inputActivityLevelViewCell)
        tableView.register(R.nib.completeButtonViewCell)
    }
}

extension FillInformationViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.inputGenderViewCell,
                                                     for: indexPath)!
            cell.configure(with: viewModel,
                           cellType: .gender)
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.inputNumberViewCell,
                                                     for: indexPath)!
            cell.configure(with: viewModel, type: .age)
            cell.configure(with: keyboardTrackViewModel)
            return cell

        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.inputNumberViewCell,
                                                     for: indexPath)!
            cell.configure(with: viewModel, type: .height)
            cell.configure(with: keyboardTrackViewModel)
            return cell

        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.inputNumberViewCell,
                                                     for: indexPath)!
            cell.configure(with: viewModel, type: .weight)
            cell.configure(with: keyboardTrackViewModel)
            return cell

        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.inputActivityLevelViewCell,
                                                     for: indexPath)!
            cell.configure(with: .activityLevel)
            cell.configure(with: viewModel)
            cell.configure(with: keyboardTrackViewModel)
            return cell

        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.showTDEEViewCell,
                                                     for: indexPath)!
            cell.configure(with: viewModel)
            return cell

        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.completeButtonViewCell,
                                                     for: indexPath)!
            cell.configure(with: viewModel)
            return cell

        default:
            let cell = UITableViewCell()
            return cell
        }
    }
}

extension FillInformationViewDataSource: UITableViewDelegate {}
