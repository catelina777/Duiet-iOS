//
//  BaseTableViewController.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/05/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxSwift
import UIKit

class BaseTableViewController: UIViewController, AppearanceChangeable {
    @IBOutlet private(set) weak var tableView: UITableView!
    let disposeBag = DisposeBag()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return AppAppearance.shared.themeService.attrs.statusBarStyle
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindAppearance()
    }

    func updateAppearance(with theme: Theme, me: BaseTableViewController) {
        me.setNeedsStatusBarAppearanceUpdate()
        tableView.backgroundColor = theme.backgroundMainColor
    }

    private func bindAppearance() {
        AppAppearance.shared.themeService.attrsStream
            .bind(to: appearanceWillUpdate)
            .disposed(by: disposeBag)
    }
}
