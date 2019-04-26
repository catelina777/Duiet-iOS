//
//  FillInformationViewController.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class FillInformationViewController: UIViewController, NavigationBarCustomizable {

    @IBOutlet private(set) weak var tableView: UITableView!

    let viewModel: FillInformationViewModel
    let dataSource: FillInformationViewDataSource

    private let disposeBag = DisposeBag()

    init() {
        self.viewModel = FillInformationViewModel()
        dataSource = FillInformationViewDataSource(viewModel: viewModel)
        super.init(nibName: FillInformationViewController.className, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.configure(with: tableView)
        configureNavigationBar(with: viewModel.title)

        viewModel.output.didTapComplete
            .bind(to: showMain)
            .disposed(by: disposeBag)
    }

    private var showMain: Binder<Void> {
        return Binder(self) { _, _ in
//            let vc = TodayViewController()
//            let nc = UINavigationController(rootViewController: vc)
//            me.present(nc, animated: true, completion: nil)
        }
    }
}
