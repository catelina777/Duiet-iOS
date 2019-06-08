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
    case detail
    case year
    case setting

    var tabBarItem: UITabBarItem {
        let tabBarItem = UITabBarItem(title: rawValue, image: UIImage(named: rawValue), selectedImage: nil)
        let padding: CGFloat = 4
        tabBarItem.imageInsets = UIEdgeInsets(top: padding, left: 0, bottom: -padding, right: 0)
        return tabBarItem
    }
}
