//
//  SettingViewDataSource.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/08.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class SettingViewDataSource: NSObject {

    private let viewModel: SettingViewModel

    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
    }

    func configure(with tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 90
        tableView.register(R.nib.settingViewCell)
    }
}

extension SettingViewDataSource: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingViewCell,
                                                 for: indexPath)!
        return cell
    }
}

extension SettingViewDataSource: UITableViewDelegate {}
