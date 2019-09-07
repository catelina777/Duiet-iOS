//
//  BaseViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/09/07.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxSwift
import UIKit

class BaseViewController: UIViewController, AppearanceChangeable {
    let disposeBag = DisposeBag()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return AppAppearance.shared.themeService.attrs.statusBarStyle
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindAppearance()
    }

    func updateAppearance(with theme: Theme, me: BaseViewController) {
        me.setNeedsStatusBarAppearanceUpdate()
        view.backgroundColor = theme.backgroundMainColor
    }

    private func bindAppearance() {
        AppAppearance.shared.themeService.attrsStream
            .bind(to: appearanceWillUpdate)
            .disposed(by: disposeBag)
    }
}
