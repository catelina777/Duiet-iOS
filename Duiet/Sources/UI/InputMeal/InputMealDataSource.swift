//
//  InputMealDataSource.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/05/03.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class InputMealDataSource: NSObject {

    let viewModel: InputMealViewModel
    let keyboardTrackViewModel: KeyboardTrackViewModel

    init(viewModel: InputMealViewModel,
         keyboardTrackViewModel: KeyboardTrackViewModel) {
        self.viewModel = viewModel
        self.keyboardTrackViewModel = keyboardTrackViewModel
    }

    func configure(with tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.register(R.nib.labelCanvasViewCell)
        tableView.register(R.nib.inputMealCalorieViewCell)
    }
}

extension InputMealDataSource: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            // MARK: Place an empty cell on the back of the header to avoid problems with tableview scrolling
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.labelCanvasViewCell,
                                                     for: indexPath)!
            cell.configure(with: viewModel)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.inputMealCalorieViewCell,
                                                     for: indexPath)!
            cell.configure(with: keyboardTrackViewModel)
            cell.configure(with: viewModel)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return tableView.bounds.width
        default:
            return 140 * 3.5
        }
    }
}

extension InputMealDataSource: UITableViewDelegate {}
