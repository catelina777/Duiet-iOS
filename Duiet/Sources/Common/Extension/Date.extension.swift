//
//  Date.extension.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/06/27.
//  Copyright © 2019 Duiet. All rights reserved.
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

    func toYearMonthString() -> String {
        return self.toString("yyyy/MM")
    }

    func year() -> Int {
        let yearFormat = "yyyy"
        formatter.dateFormat = yearFormat
        let yearString = formatter.string(from: self)
        let year = Int(yearString) ?? 1_996
        return year
    }

    func month() -> Int {
        let monthFormat = "MM"
        formatter.dateFormat = monthFormat
        var monthString = formatter.string(from: self)
        if monthString.first == "0" {
            monthString.removeFirst()
        }
        let month = Int(monthString) ?? 7
        return month
    }

    func day() -> Int {
        let dayFormat = "dd"
        formatter.dateFormat = dayFormat
        var dayString = formatter.string(from: self)
        if dayString.first == "0" {
            dayString.removeFirst()
        }
        let day = Int(dayString) ?? 17
        return day
    }

    func index() -> Int {
        return day() - 1
    }
}
