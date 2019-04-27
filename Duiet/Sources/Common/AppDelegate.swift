//
//  AppDelegate.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/04/15.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        let key = "isLaunchedBefore"
        let isLaunchedBefore = UserDefaults.standard.bool(forKey: key)

        window = UIWindow(frame: UIScreen.main.bounds)

        switch isLaunchedBefore {
        case false:
            UserDefaults.standard.set(true, forKey: key)
            let vc = WalkthroughViewController()
            window?.rootViewController = vc
            print("is first launch 🍻🍻🍻")
        case true:
            let vc = FillInformationViewController()
            window?.rootViewController = vc
            print("is not first launch 🍣🍣🍣")
        }

        window?.makeKeyAndVisible()
        return true
    }
}
