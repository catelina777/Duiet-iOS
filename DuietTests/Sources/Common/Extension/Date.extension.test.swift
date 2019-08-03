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
        self.measure {
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
        let dateComponents = DateComponents(year: year, month: month, day: day)
        let birthDate = Calendar.current.date(from: dateComponents)
        XCTAssertEqual(birthDate?.toMonthKeyString(), "\(year)/\(complement(number: month))")
        XCTAssertEqual(birthDate?.toDayKeyString(), "\(year)/\(complement(number: month))/\(complement(number: day))")
        XCTAssertEqual(birthDate?.toYearMonthString(), "\(year)/\(complement(number: month))")
        XCTAssertEqual(birthDate?.year(), year)
        XCTAssertEqual(birthDate?.month(), month)
        XCTAssertEqual(birthDate?.day(), day)
        XCTAssertEqual(birthDate?.index(), day - 1)
    }

    private func complement(number: Int) -> String {
        return number < 10 ? "0" + String(number) : String(number)
    }
}
