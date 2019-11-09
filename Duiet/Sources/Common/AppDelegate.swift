//
//  AppDelegate.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/04/15.
//  Copyright © 2019 duiet. All rights reserved.
//

import RealmSwift
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        RealmMigrationHelper.shared.doMigration()

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        appCoordinator = AppCoordinator(window: window)
        let isLaunchedBefore = UserDefaults.standard.bool(forKey: UserDefaultsKey.isLaunchedBefore)

        switch isLaunchedBefore {
        case false:
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.isLaunchedBefore)
            appCoordinator?.initialStart()
            Logger.shared.info("Is first launch 🍻🍻🍻")

        case true:
            appCoordinator?.start()
            Logger.shared.info("Is not first launch 🍣🍣🍣")
        }

        #if DEBUG
        Logger.shared.debug(RealmMigrationHelper.shared.defaultURL)
        #endif

        return true
    }
}
