//
//  Date.extension.test.swift
//  DuietTests
//
//  Created by Ryuhei Kaminishi on 2019/08/02.
//  Copyright © 2019 duiet. All rights reserved.
//

@testable import Duiet
import XCTest

class DateTests: XCTestCase {
    func testPerformance() {
        measure {
            testDateConvert()
        }
    }

    func testDateConvert () {
        let years = [1_996, 2_019]
        let months = [1, 10, 12]
        let days = [1, 10, 12]

        years.forEach { year in
            months.forEach { month in
                days.forEach { day in
                    testConvert(year: year, month: month, day: day)
                }
            }
        }
    }

    private func testConvert(year: Int, month: Int, day: Int) {
        let mockDate = MockDate.shared.create(year: year, month: month, day: day)
        XCTAssertEqual(mockDate.toMonthKeyString(), "\(year)/\(complement(number: month))")
        XCTAssertEqual(mockDate.toDayKeyString(), "\(year)/\(complement(number: month))/\(complement(number: day))")
        XCTAssertEqual(mockDate.toYearMonthString(), "\(year)/\(complement(number: month))")
        XCTAssertEqual(mockDate.year(), year)
        XCTAssertEqual(mockDate.month(), month)
        XCTAssertEqual(mockDate.day(), day)
        XCTAssertEqual(mockDate.index(), day - 1)
    }

    private func complement(number: Int) -> String {
        return number < 10 ? "0" + String(number) : String(number)
    }
}
