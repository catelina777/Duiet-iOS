//
//  TopTabBarController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/30.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class TopTabBarController: BaseTabBarController {
    private let viewModel: TopTabBarViewModel

    init(viewModel: TopTabBarViewModel,
         navigationControllers: [UIViewController]) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewControllers = navigationControllers
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

        // TODO: The function to monitor theme may be overkill, so consider removing it
        #if DEBUG
        rx.methodInvoked(#selector(traitCollectionDidChange(_:)))
            .subscribe(onNext: { [weak self] _ in
                guard let me = self else { return }
                let style = me.traitCollection.userInterfaceStyle
                AppAppearance.shared.switch(to: style)
            })
            .disposed(by: disposeBag)
        #endif
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
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
