//
//  BaseCollectionViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/08.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxSwift
import UIKit

class BaseCollectionViewController: UIViewController {
    let disposeBag = DisposeBag()
    @IBOutlet private(set) weak var collectionView: UICollectionView!
}
