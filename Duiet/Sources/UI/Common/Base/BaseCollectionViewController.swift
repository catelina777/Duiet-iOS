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
        return AppAppearance.shared.themeService.attrs.statusBarStyle
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindAppearance()
    }

    func updateAppearance(with theme: Theme, me: BaseCollectionViewController) {
        me.setNeedsStatusBarAppearanceUpdate()
        collectionView.backgroundColor = theme.backgroundMainColor
    }

    private func bindAppearance() {
        AppAppearance.shared.themeService.attrsStream
            .bind(to: appearanceWillUpdate)
            .disposed(by: disposeBag)
    }
}
