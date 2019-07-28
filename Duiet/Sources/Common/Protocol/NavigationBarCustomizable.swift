//
//  NavigationBarCustomizable.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/19.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

protocol NavigationBarCustomizable {
    func configureNavigationBar(with title: String)
}

extension NavigationBarCustomizable where Self: UIViewController {

    func configureNavigationBar(with title: String) {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = R.color.title()
        let largeTitleFont = R.font.montserratExtraBold(size: 32)!
        let titleText = R.font.montserratExtraBold(size: 18)!
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: largeTitleFont]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: titleText]
        self.title = title
    }
}
