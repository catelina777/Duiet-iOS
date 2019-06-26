//
//  BaseTableViewController.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/05/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift

class BaseTableViewController: UIViewController {

    let disposeBag = DisposeBag()
    @IBOutlet private(set) weak var tableView: UITableView!
}