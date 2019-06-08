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
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }

    func start(with window: UIWindow) {
        let todayNC = get(scene: .today)
        let detailNC = get(scene: .detail)
        let yearNC = get(scene: .year)
        let settingNC = get(scene: .setting)

        // TODO: - delete under test
        let vc = FillInformationViewController()
        let nc = UINavigationController(rootViewController: vc)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            todayNC,
            nc,
            yearNC,
            settingNC
        ]
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

    private func get(scene: SceneType) -> UINavigationController {
        var nc: UINavigationController
        switch scene {
        case .today:
            let vc = TodayViewController()
            nc = UINavigationController(rootViewController: vc)
        case .detail:
            let vc = TodayViewController()
            nc = UINavigationController(rootViewController: vc)
        case .year:
            let vc = TodayViewController()
            nc = UINavigationController(rootViewController: vc)
        case .setting:
            let vc = SettingViewController()
            nc = UINavigationController(rootViewController: vc)
        }
        nc.tabBarItem = scene.tabBarItem
        return nc
    }
}
