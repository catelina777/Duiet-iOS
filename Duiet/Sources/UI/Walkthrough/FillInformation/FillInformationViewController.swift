//
//  FillInformationViewController.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class FillInformationViewController: BaseTableViewController, NavigationBarCustomizable, KeyboardFrameTrackkable {
    let viewModel: FillInformationViewModelProtocol
    let dataSource: FillInformationViewDataSource

    let keyboardTrackViewModel: KeyboardTrackViewModel

    init(viewModel: FillInformationViewModelProtocol) {
        self.viewModel = viewModel
        self.keyboardTrackViewModel = KeyboardTrackViewModel()
        dataSource = FillInformationViewDataSource(viewModel: viewModel,
                                                   keyboardTrackViewModel: keyboardTrackViewModel)
        super.init(nibName: FillInformationViewController.className, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.configure(with: tableView)
        // TODO: Consider creating an enum that holds the titles
        configureNavigationBar(with: "Calculate",
                               isLargeTitles: true)

        keyboardTrackViewModel.output.difference
            .bind(to: updateScroll)
            .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
