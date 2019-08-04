//
//  DayRepositoryTests.swift
//  DuietTests
//
//  Created by Ryuhei Kaminishi on 2019/08/03.
//  Copyright © 2019 duiet. All rights reserved.
//

@testable import Duiet
import RealmSwift
import XCTest

class DayRepositoryTests: DBUnitTestCase {
    enum MockData {
        static let year = 1_996
        static let month = 7
        static let date = 17
        static let imagePath = "test-image"
        static let relativeX1 = Double.random(in: 0..<300)
        static let relativeY1 = Double.random(in: 0..<300)
        static let relativeX2 = Double.random(in: 0..<300)
        static let relativeY2 = Double.random(in: 0..<300)
    }

    var mockDate: Date!
    var realm: Realm!

    override func setUp() {
        mockDate = MockDate.shared.create(year: MockData.year, month: MockData.month, day: MockData.date)
        realm = try! Realm()
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testAddFindMealThenAddContent() {
        let monthResults = realm.objects(Month.self)
        let dayResults = realm.objects(Day.self)
        let mealResults = realm.objects(Meal.self)
        let contentResults = realm.objects(Content.self)

        XCTAssertEqual(monthResults.count, 0)
        XCTAssertEqual(dayResults.count, 0)
        XCTAssertEqual(mealResults.count, 0)
        let day = DayRepository.shared.findOrCreate(day: mockDate)
        XCTAssertEqual(monthResults.count, 1)
        XCTAssertEqual(dayResults.count, 1)
        XCTAssertEqual(day.createdAt, mockDate)

        let mockMeal = Meal(imagePath: MockData.imagePath, date: mockDate)
        XCTAssertEqual(mealResults.count, 0)
        DayRepository.shared.add(meal: mockMeal, to: day)
        XCTAssertEqual(mealResults.count, 1)
        XCTAssertEqual(mealResults.first!.imagePath, mockMeal.imagePath)

        let mockContent1 = Content(relativeX: MockData.relativeX1, relativeY: MockData.relativeY1)
        XCTAssertEqual(contentResults.count, 0)
        DayRepository.shared.add(content: mockContent1, to: mockMeal)
        XCTAssertEqual(contentResults.count, 1)
        let acquiredMeal = mealResults[0]
        XCTAssertEqual(acquiredMeal.contents[0].relativeX, MockData.relativeX1)
        XCTAssertEqual(acquiredMeal.contents[0].relativeY, MockData.relativeY1)

        let mockContent2 = Content(relativeX: MockData.relativeX2, relativeY: MockData.relativeY2)
        DayRepository.shared.add(content: mockContent2, to: mockMeal)
        XCTAssertEqual(contentResults.count, 2)
        XCTAssertEqual(acquiredMeal.contents[1].relativeX, MockData.relativeX2)
        XCTAssertEqual(acquiredMeal.contents[1].relativeY, MockData.relativeY2)
    }
}
