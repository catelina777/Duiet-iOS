//
//  SelectActivityLevelViewController.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/18.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift

final class SelectActivityLevelViewController: UIViewController, NavigationBarCustomizable {

    @IBOutlet weak var tableView: UITableView!

    let viewModel: SelectActivityLevelViewModel
    let dataSource: SelectActivityLevelViewDataSource

    private let disposeBag = DisposeBag()

    init(fillInformationOutput: Observable<ActivityLevel?>,
         fillInformationInput: AnyObserver<ActivityLevel?>) {
        self.viewModel = SelectActivityLevelViewModel(fillInformationInput: fillInformationInput,
                                                      fillInformationOutput: fillInformationOutput)
        self.dataSource = SelectActivityLevelViewDataSource(viewModel: viewModel)
        super.init(nibName: SelectActivityLevelViewController.className,
                   bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.configure(with: tableView)
        configureNavigationBar(with: "Activity Level")

        viewModel.output.activityLevel
            .subscribe(onNext: { [weak self] level in
                print(level)
            })
            .disposed(by: disposeBag)
    }
}
