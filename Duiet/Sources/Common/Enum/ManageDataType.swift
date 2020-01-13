//
//  ManageDataType.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/23.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

enum ManageDataType: CaseIterable {
    case export
    case `import`

    var title: String {
        switch self {
        case .export:
            return "📤 " + R.string.localizable.exportTitle()

        case .import:
            return "📤 " + R.string.localizable.importTitle()
        }
    }

    var description: String {
        switch self {
        case .import:
            return R.string.localizable.exportDescription()

        case .export:
            return R.string.localizable.importDescription()
        }
    }
}
