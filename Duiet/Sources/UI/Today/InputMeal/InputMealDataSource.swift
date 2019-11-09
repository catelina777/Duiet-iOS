//
//  InputMealDataSource.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/05/03.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class InputMealDataSource: NSObject {
    let viewModel: InputMealViewModelProtocol
    let keyboardTrackViewModel: KeyboardTrackViewModel

    init(viewModel: InputMealViewModelProtocol,
         keyboardTrackViewModel: KeyboardTrackViewModel) {
        self.viewModel = viewModel
        self.keyboardTrackViewModel = keyboardTrackViewModel
    }

    func configure(with tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.register(R.nib.emptyContentViewCell)
        tableView.register(R.nib.labelCanvasViewCell)
        tableView.register(R.nib.inputMealInformationViewCell)
    }

    deinit {
        Logger.shared.info("🧹memory released🧹")
    }
}

extension InputMealDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            // MARK: Place an empty cell on the back of the header to avoid problems with tableview scrolling
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.labelCanvasViewCell,
                                                     for: indexPath)!
            cell.configure(input: viewModel.input,
                           output: viewModel.output,
                           state: viewModel.state)
            return cell

        default:
            // Display when mealLabelviews are empty
            if viewModel.state.contents.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.emptyContentViewCell,
                                                         for: indexPath)!
                return cell
            }

            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.inputMealInformationViewCell,
                                                     for: indexPath)!
            cell.configure(input: keyboardTrackViewModel.input, output: keyboardTrackViewModel.output)
            cell.configureTextField(input: viewModel.input, output: viewModel.output)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return tableView.bounds.width

        default:
            return 140 * 2.8
        }
    }
}

extension InputMealDataSource: UITableViewDelegate {}
