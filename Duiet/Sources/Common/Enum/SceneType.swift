//
//  SceneType.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/08.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

enum SceneType: String {
    case today
    case days
    case months
    case setting

    var tabBarItem: UITabBarItem {
        let tabBarItem = UITabBarItem(title: title, image: UIImage(named: rawValue), selectedImage: nil)
        let padding: CGFloat = 4
        tabBarItem.imageInsets = UIEdgeInsets(top: padding, left: 0, bottom: -padding, right: 0)
        return tabBarItem
    }

    var title: String {
        switch self {
        case .today:
            return R.string.localizable.today()

        case .days:
            return R.string.localizable.days()

        case .months:
            return R.string.localizable.months()

        case .setting:
            return R.string.localizable.setting()
        }
    }
}
