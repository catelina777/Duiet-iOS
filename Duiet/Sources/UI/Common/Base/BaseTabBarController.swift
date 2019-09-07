//
//  BaseTabBarController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/09/07.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxSwift
import UIKit

class BaseTabBarController: UITabBarController, AppearanceChangeable {
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        bindAppearance()
    }

    func updateAppearance(with theme: Theme, me: BaseTabBarController) {
        tabBar.tintColor = theme.tabBarTintColor
        tabBar.barTintColor = theme.tabBarBarTintColor
    }

    private func bindAppearance() {
        AppAppearance.shared.themeService.attrsStream
            .bind(to: appearanceWillUpdate)
            .disposed(by: disposeBag)
    }
}
