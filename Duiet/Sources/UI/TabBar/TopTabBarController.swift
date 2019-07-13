//
//  TopTabBarController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/30.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TopTabBarController: UITabBarController {

    private let viewModel: TopTabBarViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: TopTabBarViewModel,
         navigationControllers: [UIViewController]) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = navigationControllers
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.output.showDetailDay
            .map { _ in }
            .bind(to: showDetailDay)
            .disposed(by: disposeBag)

        viewModel.output.showDays
            .map { _ in }
            .bind(to: showDays)
            .disposed(by: disposeBag)
    }

    var showDetailDay: Binder<Void> {
        return Binder(self) { me, _ in
            me.selectedIndex = 0
        }
    }

    var showDays: Binder<Void> {
        return Binder(self) { me, _ in
            me.selectedIndex = 1
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        for nc in self.viewControllers! {
            _ = nc.children[0].view
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
