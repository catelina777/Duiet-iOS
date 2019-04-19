//
//  SelectActivityLevelViewDataSource.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/18.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class SelectActivityLevelViewDataSource: NSObject {

    private let viewModel: SelectActivityLevelViewModel

    init(viewModel: SelectActivityLevelViewModel) {
        self.viewModel = viewModel
    }

    func configure(with tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        tableView.register(R.nib.activityLevelViewCell)
    }
}

extension SelectActivityLevelViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.activityLevelViewCell,
                                                 for: indexPath)!
        cell.configure(with: .lightly)
        return cell
    }
}

extension SelectActivityLevelViewDataSource: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.input.selectedIndexPath.onNext(indexPath)
    }
}
