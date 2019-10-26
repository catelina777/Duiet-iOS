//
//  SceneType.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/08.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

enum SceneType: String {
    case histories
    case setting

    var tabBarItem: UITabBarItem {
        switch self {
        case .histories:
            return UITabBarItem(title: title, image: UIImage(systemName: "calendar"), selectedImage: nil)

        case .setting:
            return UITabBarItem(title: title, image: UIImage(systemName: "gear"), selectedImage: nil)
        }
    }

    var title: String {
        switch self {
        case .histories:
            return "Histories"

        case .setting:
            return R.string.localizable.setting()
        }
    }
}
