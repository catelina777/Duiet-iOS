//
//  SettingType.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/20.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

enum SettingType: CaseIterable {
    case editInfo
    case editUnit
    case manageData

    var contentText: String {
        switch self {
        case .editInfo:
            return "✍️ " + R.string.localizable.editUserInformation()

        case .editUnit:
            return "📏 " + R.string.localizable.reselectUnits()

        case .manageData:
            return "💾 " + R.string.localizable.manageData()
        }
    }
}
