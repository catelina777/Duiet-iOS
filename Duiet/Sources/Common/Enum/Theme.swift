//
//  Theme.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/08/31.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxSwift
import RxTheme
import UIKit

protocol Theme {
    var titleColor: UIColor { get }
    var textMainColor: UIColor { get }
    var buttonMainColor: UIColor { get }
    var buttonDisableColor: UIColor { get }
    var backgroundMainColor: UIColor { get }
    var tabBarTintColor: UIColor { get }
    var navigationBarTintColor: UIColor { get }
    var cellHighlightColor: UIColor { get }
    var progressExceedColor: UIColor { get }
    var progressLessColor: UIColor { get }
    var progressNoneColor: UIColor { get }
    var statusBarStyle: UIStatusBarStyle { get }
}

struct LightTheme: Theme {
    let titleColor             = UIColor(hex: "3E4158", alpha: 1)
    let textMainColor          = UIColor(hex: "FFFFFF", alpha: 1)
    let buttonMainColor        = UIColor(hex: "007AFF", alpha: 1)
    let buttonDisableColor     = UIColor(hex: "999999", alpha: 1)
    let backgroundMainColor    = UIColor(hex: "F2F2F2", alpha: 1)
    let tabBarTintColor        = UIColor(hex: "FFFFFF", alpha: 1)
    let navigationBarTintColor = UIColor(hex: "FFFFFF", alpha: 1)
    let cellHighlightColor     = UIColor(hex: "00BAFF", alpha: 0.08)
    let progressExceedColor    = UIColor(hex: "EE5787", alpha: 1)
    let progressLessColor      = UIColor(hex: "007AFF", alpha: 1)
    let progressNoneColor      = UIColor(hex: "E7E8E9", alpha: 1)
    let statusBarStyle         = UIStatusBarStyle.default
}

struct DarkTheme: Theme {
    let titleColor             = UIColor(hex: "EEEEEE", alpha: 1)
    let textMainColor          = UIColor(hex: "39C1BC", alpha: 1)
    let buttonMainColor        = UIColor(hex: "39C1BC", alpha: 1)
    let buttonDisableColor     = UIColor(hex: "8D8D8D", alpha: 1)
    let backgroundMainColor    = UIColor(hex: "000000", alpha: 1)
    let tabBarTintColor        = UIColor(hex: "000000", alpha: 1)
    let navigationBarTintColor = UIColor(hex: "000000", alpha: 1)
    let cellHighlightColor     = UIColor(hex: "39C1BC", alpha: 0.08)
    let progressExceedColor    = UIColor(hex: "BF5F82", alpha: 1)
    let progressLessColor      = UIColor(hex: "39C1BC", alpha: 1)
    let progressNoneColor      = UIColor(hex: "2E3038", alpha: 1)
    let statusBarStyle         = UIStatusBarStyle.lightContent
}

enum ThemeType: ThemeProvider {
    case light, dark

    var associatedObject: Theme {
        switch self {
        case .light:
            return LightTheme()

        case .dark:
            return DarkTheme()
        }
    }

    init(value: Int) {
        switch value {
        case 0:
            self = .light

        case 1:
            self = .dark

        default:
            self = .light
        }
    }

    var value: Int {
        switch self {
        case .light:
            return 0

        case .dark:
            return 1
        }
    }
}
