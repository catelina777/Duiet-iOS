//
//  TopTabBarController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/30.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class TopTabBarController: BaseTabBarController {
    init(navigationControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        viewControllers = navigationControllers
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        for nc in self.viewControllers! {
            _ = nc.children[0].view
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
