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
        switch self {
        case .today:
            return UITabBarItem(title: title, image: UIImage(systemName: "calendar"), selectedImage: nil)

        case .days:
            return UITabBarItem(title: title, image: UIImage(systemName: "square.split.1x2.fill"), selectedImage: nil)

        case .months:
            return UITabBarItem(title: title, image: UIImage(systemName: "square.split.2x2.fill"), selectedImage: nil)

        case .setting:
            return UITabBarItem(title: title, image: UIImage(systemName: "gear"), selectedImage: nil)
        }
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
