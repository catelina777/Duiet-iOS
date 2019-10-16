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

    init(viewModel: SelectUnitViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: SelectUnitViewController.className, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
