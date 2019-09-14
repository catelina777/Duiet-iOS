//
//  BaseTabBarController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/09/07.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxSwift
import UIKit

class BaseTabBarController: UITabBarController {
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        bindAppearance()
    }

    func bindAppearance() {
        tabBar.tintColor = R.color.componentMain()!
    }
}
