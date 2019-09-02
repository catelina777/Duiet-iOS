//
//  AppearanceChangeable.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/09/01.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxCocoa

protocol AppearanceChangeable: AnyObject {
    var appearanceWillUpdate: Binder<ThemeType> { get }

    func updateAppearance(with theme: ThemeType, me: Self)
}

extension AppearanceChangeable {
    var appearanceWillUpdate: Binder<ThemeType> {
        return Binder(self) { me, themeType in
            me.updateAppearance(with: themeType, me: me)
        }
    }
}
