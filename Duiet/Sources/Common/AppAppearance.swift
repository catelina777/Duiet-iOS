//
//  AppAppearance.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/08/31.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxTheme

final class AppAppearance {
    static let shared = AppAppearance()

    static let themeKey = "Duiet-app-theme"

    let themeService: ThemeService<ThemeType> = {
        let themeTypeValue = (UserDefaults.standard.object(forKey: UserDefaultsKey.appTheme) as? Int) ?? 0
        let themeType = ThemeType(value: themeTypeValue)
        return ThemeType.service(initial: themeType)
    }()

    var themeWillUpdate: Binder<ThemeType> {
        return Binder(self) { me, type in
            UserDefaults.standard.set(type.value, forKey: UserDefaultsKey.appTheme)
            me.themeService.switch(type)
        }
    }

    func appty<T>(_ mapper: @escaping ((Theme) -> T)) -> Observable<T> {
        return themeService.attrStream(mapper)
    }
}
