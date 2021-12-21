//
//  NSObjectProtocol.extension.swift
//  ToolKits
//
//  Created by Ryuhei Kaminishi on 2019/12/12.
//  Copyright © 2019 catelina777. All rights reserved.
//

import Foundation

public extension NSObjectProtocol {
    static var className: String {
        String(describing: self)
    }
}
