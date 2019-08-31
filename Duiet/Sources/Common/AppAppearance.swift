//
//  AppAppearance.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/08/31.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift
import RxTheme

final class AppAppearance {
    static let shared = AppAppearance()

    let themeService = ThemeType.service(initial: .light)

    func themeDidUpdate<T>(_ mapper: @escaping ((Theme) -> T)) -> Observable<T> {
        return themeService.attrStream(mapper)
    }
}
