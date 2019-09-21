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

    var contentText: String {
        switch self {
        case .editInfo:
            return "✍️ " + R.string.localizable.editUserInformation()
        }
    }
}
