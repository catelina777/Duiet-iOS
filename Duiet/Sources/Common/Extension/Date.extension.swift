//
//  Date.extension.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/06/27.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

private let formatter: DateFormatter = {
    let formatter = DateFormatter()
    return formatter
}()

private let keyFormatter: DateFormatter = {
    let formatter = DateFormatter()
    return formatter
}()

extension Date {

    func toKeyString() -> String {
        keyFormatter.dateStyle = .short
        keyFormatter.timeStyle = .none
        return keyFormatter.string(from: self)
    }

    func toString(_ format: String = "yyyy/MM/dd") -> String {
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
