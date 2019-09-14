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

    private let disposeBag = DisposeBag()

    let themeService: ThemeService<ThemeType> = {
        let themeTypeValue = (UserDefaults.standard.object(forKey: UserDefaultsKey.appTheme) as? Int) ?? 0
        let themeType = ThemeType(value: themeTypeValue)
        return ThemeType.service(initial: themeType)
    }()

    var themeWillUpdate: Binder<ThemeType> {
        return Binder(self) { _, type in
            UserDefaults.standard.set(type.value, forKey: UserDefaultsKey.appTheme)
        }
    }

    func appty<T>(_ mapper: @escaping ((Theme) -> T)) -> Observable<T> {
        return themeService.attrStream(mapper)
    }

    func `switch`(to style: UIUserInterfaceStyle) {
        print("switch to \(style)")
        switch style {
        case .dark:
            themeService.switch(.dark)

        default:
            themeService.switch(.light)
        }
    }

    func start() {
        themeService.typeStream
            .bind(to: themeWillUpdate)
            .disposed(by: disposeBag)
    }
}
