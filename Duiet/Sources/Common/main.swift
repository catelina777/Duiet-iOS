//
//  main.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/08/03.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

enum Global {
    static var isUnitTest: Bool {
        return ProcessInfo.processInfo.environment["isUnitTest"] == "true"
    }
}

private var appDelegateName: String {
    if Global.isUnitTest {
        return NSStringFromClass(UnitTestAppDelegate.self)
    } else {
        return NSStringFromClass(AppDelegate.self)
    }
}

_ = UIApplicationMain(CommandLine.argc,
                      CommandLine.unsafeArgv,
                      NSStringFromClass(UIApplication.self),
                      appDelegateName)
