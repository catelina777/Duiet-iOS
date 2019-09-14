//
//  BaseTableViewController.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/05/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxSwift
import UIKit

class BaseTableViewController: UIViewController{
    @IBOutlet private(set) weak var tableView: UITableView!
    let disposeBag = DisposeBag()
}
