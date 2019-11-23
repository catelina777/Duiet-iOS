//
//  AppDelegate.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/04/15.
//  Copyright © 2019 duiet. All rights reserved.
//

import Firebase
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        appCoordinator = AppCoordinator(window: window)
        let isLaunchedBefore = UserDefaults.standard.bool(forKey: UserDefaultsKey.isLaunchedBefore)

        switch isLaunchedBefore {
        case false:
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.isLaunchedBefore)
            appCoordinator?.initialStart()

        case true:
            appCoordinator?.start()
        }

        return true
    }
}
