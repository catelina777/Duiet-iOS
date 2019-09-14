//
//  BaseNavigationController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/09/07.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxSwift
import UIKit

class BaseNavigationController: UINavigationController {
    let disposeBag = DisposeBag()

    override var childForStatusBarStyle: UIViewController? {
        return visibleViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindAppearance()
    }

    func bindAppearance() {
        navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: R.font.montserratExtraBold(size: 32)!
        ]

        navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: R.font.montserratExtraBold(size: 18)!
        ]

        navigationBar.tintColor = UIColor.label
    }
}
