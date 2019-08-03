//
//  MockDate.swift
//  DuietTests
//
//  Created by Ryuhei Kaminishi on 2019/08/03.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

class MockDate {
    static let shared = MockDate()

    private var dateComponents: DateComponents

    private init() {
        self.dateComponents = DateComponents()
    }

    func create(year: Int, month: Int, day: Int) -> Date {
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return Calendar.current.date(from: dateComponents)!
    }
}
