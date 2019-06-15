//
//  BaseCollectionViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/08.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift

class BaseCollectionViewController: UIViewController {

    private let disposeBag = DisposeBag()
    @IBOutlet private(set) weak var collectionView: UICollectionView!
}
