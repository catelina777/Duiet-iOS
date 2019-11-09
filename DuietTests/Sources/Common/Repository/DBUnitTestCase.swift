//
//  DBUnitTestCase.swift
//  DuietTests
//
//  Created by Ryuhei Kaminishi on 2019/08/03.
//  Copyright © 2019 duiet. All rights reserved.
//

@testable import Duiet
import Foundation
import RealmSwift
import XCTest

class DBUnitTestCase: XCTestCase {
    var realm: Realm!

    override func setUp() {
        reset()
    }

    override func tearDown() {
        reset()
    }

    func reset() {
        realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        Logger.shared.debug("🗑🗑🗑 DB reset 🗑🗑🗑")
    }
}
