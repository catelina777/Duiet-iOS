//
//  AppNavigator.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/08.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class AppNavigator {

    static let shared = AppNavigator()

    func firstStart(with window: UIWindow) {
        let vc = WalkthroughViewController()
        let nc = UINavigationController(rootViewController: vc)
        window.rootViewController = nc
        window.makeKeyAndVisible()
    }

    func start(with window: UIWindow) {
        let tabBarController = getMain()
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

    func start(with vc: UIViewController) {
        let tabBarController = getMain()
        vc.present(tabBarController, animated: true, completion: nil)
    }

    private func getMain() -> UITabBarController {
        let dayNC = get(scene: .day)
        let monthNC = get(scene: .month)
        let yearNC = get(scene: .year)
        let settingNC = get(scene: .setting)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            dayNC,
            monthNC,
            yearNC,
            settingNC
        ]
        return tabBarController
    }

    private func get(scene: SceneType) -> UINavigationController {
        var nc: UINavigationController
        switch scene {
        case .day:
            let vc = DayViewController()
            nc = UINavigationController(rootViewController: vc)
        case .month:
            let vc = MonthViewController()
            nc = UINavigationController(rootViewController: vc)
        case .year:
            let vc = YearViewController()
            nc = UINavigationController(rootViewController: vc)
        case .setting:
            let vc = SettingViewController()
            nc = UINavigationController(rootViewController: vc)
        }
        nc.tabBarItem = scene.tabBarItem
        return nc
    }
}
