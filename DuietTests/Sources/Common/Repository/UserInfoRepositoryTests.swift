//
//  UserInfoRepositoryTests.swift
//  DuietTests
//
//  Created by Ryuhei Kaminishi on 2019/08/02.
//  Copyright © 2019 duiet. All rights reserved.
//

@testable import Duiet
import XCTest

class UserInfoRepositoryTests: XCTestCase {
    func testAddGet() {
        let mock1 = MockUserInfo(gender: true, age: 23, height: 168, weight: 62, activityLevel: .none)
        let mock2 = MockUserInfo(gender: false, age: 28, height: 168, weight: 62, activityLevel: .moderately)
        let mockUserInfo1 = UserInfo(gender: mock1.gender,
                                     age: mock1.age,
                                     height: mock1.height,
                                     weight: mock1.weight,
                                     activityLevel: mock1.activityLevel)
        UserInfoRepository.shared.add(userInfo: mockUserInfo1)
        let userInfo = UserInfoRepository.shared.get()
        XCTAssertEqual(userInfo.count, 1)
        XCTAssertTrue(userInfo.first?.gender == mock1.gender)
        XCTAssertFalse(userInfo.first?.gender == mock2.gender)
    }

    func testAddUpdate() {
        let mock1 = MockUserInfo(gender: true, age: 23, height: 168, weight: 62, activityLevel: .none)
        let mock2 = MockUserInfo(gender: false, age: 28, height: 168, weight: 62, activityLevel: .moderately)
        let mockUserInfo1 = UserInfo(gender: mock1.gender,
                                     age: mock1.age,
                                     height: mock1.height,
                                     weight: mock1.weight,
                                     activityLevel: mock1.activityLevel)
        let mockUserInfo2 = UserInfo(gender: mock2.gender,
                                     age: mock2.age,
                                     height: mock2.height,
                                     weight: mock2.weight,
                                     activityLevel: mock2.activityLevel)

        UserInfoRepository.shared.add(userInfo: mockUserInfo1)
        let userInfo = UserInfoRepository.shared.get()
        XCTAssertTrue(userInfo.first?.gender == mock1.gender)
        XCTAssertFalse(userInfo.first?.gender == mock2.gender)
        XCTAssertEqual(userInfo.count, 1)

        UserInfoRepository.shared.add(userInfo: mockUserInfo2)
        XCTAssertFalse(userInfo.first?.gender == mock1.gender)
        XCTAssertTrue(userInfo.first?.gender == mock2.gender)
        XCTAssertEqual(userInfo.count, 1)
    }

    struct MockUserInfo {
        let gender: Bool
        let age: Int
        let height: Double
        let weight: Double
        let activityLevel: ActivityLevel
    }
}
