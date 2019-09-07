//
//  BaseNavigationController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/09/07.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxSwift
import UIKit

class BaseNavigationController: UINavigationController, AppearanceChangeable {
    let disposeBag = DisposeBag()

    override var childForStatusBarStyle: UIViewController? {
        return visibleViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindAppearance()
    }

    func updateAppearance(with theme: Theme, me: BaseNavigationController) {
        me.setNeedsStatusBarAppearanceUpdate()
        navigationBar.barTintColor = theme.navigationBarBarTintColor
        navigationBar.tintColor = theme.navigationBarTintColor
        navigationBar.largeTitleTextAttributes = [
            .foregroundColor: theme.titleColor,
            .font: R.font.montserratExtraBold(size: 32)!
        ]
        navigationBar.titleTextAttributes = [
            .foregroundColor: theme.titleColor,
            .font: R.font.montserratExtraBold(size: 18)!
        ]
    }

    private func bindAppearance() {
        AppAppearance.shared.themeService.attrsStream
            .bind(to: appearanceWillUpdate)
            .disposed(by: disposeBag)
    }
}
