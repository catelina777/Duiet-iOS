//
//  BaseCollectionViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/08.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class BaseCollectionViewController: UIViewController {
    @IBOutlet private(set) weak var collectionView: UICollectionView!
    let disposeBag = DisposeBag()

    func bindRefreshThenReloadData() {
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl

        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: reloadData)
            .disposed(by: disposeBag)
    }

    /// Reload CollectionView then end refreshing
    private var reloadData: Binder<Void> {
        Binder<Void>(self) { me, _ in
            me.collectionView.reloadData()
            me.collectionView.refreshControl?.endRefreshing()
        }
    }
}
