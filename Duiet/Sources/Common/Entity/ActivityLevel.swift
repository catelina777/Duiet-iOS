//
//  ActivityLevel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/09/28.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift

final class ActivityLevel: Object {
    @objc dynamic var row = 0
    @objc dynamic var createdAt = Date()

    required convenience init(activityLevel: ActivityLevelType) {
        self.init()
        row = activityLevel.row
        createdAt = Date()
    }
}
