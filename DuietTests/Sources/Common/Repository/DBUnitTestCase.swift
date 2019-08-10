//
//  DBUnitTestCase.swift
//  DuietTests
//
//  Created by Ryuhei Kaminishi on 2019/08/03.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift
import XCTest

class DBUnitTestCase: XCTestCase {
    override func setUp() {
        reset()
    }

    override func tearDown() {
        reset()
    }

    func reset() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        print("🗑🗑🗑 DB reset 🗑🗑🗑")
    }
}
