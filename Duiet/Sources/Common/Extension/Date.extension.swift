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

extension Date {

    func toMonthKeyString() -> String {
        return self.toString("yyyy/MM")
    }

    func toDayKeyString() -> String {
        return self.toString("yyyy/MM/dd")
    }

    func toString(_ format: String = "yyyy/MM/dd") -> String {
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
