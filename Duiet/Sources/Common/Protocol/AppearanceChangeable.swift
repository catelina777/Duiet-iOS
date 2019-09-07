//
//  AppearanceChangeable.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/09/01.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxCocoa

protocol AppearanceChangeable: AnyObject {
    var appearanceWillUpdate: Binder<Theme> { get }

    func updateAppearance(with theme: Theme, me: Self)
}

extension AppearanceChangeable {
    var appearanceWillUpdate: Binder<Theme> {
        return Binder(self) { me, theme in
            me.updateAppearance(with: theme, me: me)
        }
    }
}
