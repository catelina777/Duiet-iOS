//
//  SelectUnitViewDataSource.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/10/16.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxSwift
import UIKit

final class SelectUnitViewDataSource: NSObject {
    private let viewModel: SelectUnitViewModelProtocol
    private let unitInputs: [AnyObserver<Int?>]

    init(viewModel: SelectUnitViewModelProtocol) {
        self.viewModel = viewModel
        unitInputs = [viewModel.input.heightUnitRow,
                      viewModel.input.weightUnitRow,
                      viewModel.input.energyUnitRow]
    }

    func configure(with tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 140
        tableView.register(R.nib.selectElementViewCell.self)
    }
}

extension SelectUnitViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SelectUnitCellType.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = SelectUnitCellType.allCases[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.selectElementViewCell, for: indexPath)!
        cell.configure(with: type, isSelectedLeft: unitInputs[indexPath.row])
        return cell
    }
}

extension SelectUnitViewDataSource: UITableViewDelegate {}
