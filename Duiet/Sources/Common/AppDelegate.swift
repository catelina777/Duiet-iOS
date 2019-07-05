//
//  AppDelegate.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/04/15.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        /* insert seed data
        let seedmanager = SeedManager()
        seedmanager.generate()
        */

        let key = "isLaunchedBefore"
        let isLaunchedBefore = UserDefaults.standard.bool(forKey: key)

        switch isLaunchedBefore {
        case false:
            UserDefaults.standard.set(true, forKey: key)
            AppCoordinator.shared.initialStart(in: window)
            print("is first launch 🍻🍻🍻")
        case true:
            AppCoordinator.shared.start(in: window)
            print("is not first launch 🍣🍣🍣")
        }

        print(Realm.Configuration.defaultConfiguration.fileURL!)

        return true
    }
}
