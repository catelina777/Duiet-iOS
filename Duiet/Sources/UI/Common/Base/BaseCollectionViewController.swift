//
//  BaseCollectionViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/08.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxSwift
import UIKit

class BaseCollectionViewController: UIViewController, AppearanceChangeable {
    @IBOutlet private(set) weak var collectionView: UICollectionView!

    let disposeBag = DisposeBag()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        print("status bar changed")
        return AppAppearance.shared.themeService.attrs.statusBarStyle
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindAppearance()
    }

    func updateAppearance(with theme: Theme, me: BaseCollectionViewController) {
        print("appearance did update")
        me.setNeedsStatusBarAppearanceUpdate()
        collectionView.backgroundColor = theme.backgroundMainColor
    }

    private func bindAppearance() {
        print("bind appearance")
        print(AppAppearance.shared.themeService.attrs.statusBarStyle.rawValue)
        AppAppearance.shared.themeService.attrsStream
            .bind(to: appearanceWillUpdate)
            .disposed(by: disposeBag)
    }
}
