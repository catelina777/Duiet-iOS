//
//  NavigationBarCustomizable.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/19.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

protocol NavigationBarCustomizable {
    func configureNavigationBar(with title: String, isLargeTitles: Bool)
}

extension NavigationBarCustomizable where Self: UIViewController {
    func configureNavigationBar(with title: String, isLargeTitles: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = isLargeTitles
        self.title = title
    }
}
