//
//  NSObjectProtocol.extension.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/19.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

extension NSObjectProtocol {
    static var className: String {
        String(describing: self)
    }
}
