//
//  UnitCollectionTests.swift
//  DuietTests
//
//  Created by Ryuhei Kaminishi on 2019/10/20.
//  Copyright © 2019 duiet. All rights reserved.
//

@testable import Duiet
import RealmSwift
import RxBlocking
import XCTest

class UnitCollectionTests: DBUnitTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testAddGet() {
        let mock1 = MockUnitCollection(testRow1: 0, testRow2: 1, testRow3: 1)
        let mockUnitCollection1 = UnitCollection(heightUnitRow: mock1.testRow1,
                                                 weightUnitRow: mock1.testRow2,
                                                 energyUnitRow: mock1.testRow3)
        let unitCollection = UnitCollectionRepository.shared.get()
        let emptyResults = realm.objects(UnitCollection.self)
        XCTAssertEqual(emptyResults.count, 0)

        UnitCollectionRepository.shared.add(unitCollection: mockUnitCollection1)
        let thereIsOneResult = try! unitCollection
            .toBlocking()
            .first()
        XCTAssertNotNil(thereIsOneResult)
        XCTAssertTrue(thereIsOneResult?.heightUnitRow == mock1.testRow1)
    }

    func testAddUpdate() {
        let mock1 = MockUnitCollection(testRow1: 0, testRow2: 1, testRow3: 1)
        let mock2 = MockUnitCollection(testRow1: 1, testRow2: 0, testRow3: 0)
        let mockUnitCollection1 = UnitCollection(heightUnitRow: mock1.testRow1,
                                                 weightUnitRow: mock1.testRow2,
                                                 energyUnitRow: mock1.testRow3)
        let mockUnitCollection2 = UnitCollection(heightUnitRow: mock2.testRow1,
                                                 weightUnitRow: mock2.testRow2,
                                                 energyUnitRow: mock2.testRow3)
        //　Test whether the expected UserInfo has been added
        let unitCollection = UnitCollectionRepository.shared.get()
        let emptyResults = realm.objects(UnitCollection.self)
        XCTAssertEqual(emptyResults.count, 0)

        UnitCollectionRepository.shared.add(unitCollection: mockUnitCollection1)
        let thereIsOneResult = try! unitCollection
            .toBlocking()
            .first()
        XCTAssertNotNil(thereIsOneResult)
        XCTAssertTrue(thereIsOneResult?.heightUnitRow == mock1.testRow1)

        // Test if the expected UserInfo has been updated
        UnitCollectionRepository.shared.add(unitCollection: mockUnitCollection2)
        let updatedResult = try! unitCollection
            .toBlocking()
            .first()
        XCTAssertNotNil(updatedResult)
        XCTAssertTrue(updatedResult?.heightUnitRow == mock2.testRow1)
    }

    struct MockUnitCollection {
        let testRow1: Int
        let testRow2: Int
        let testRow3: Int
    }
}
