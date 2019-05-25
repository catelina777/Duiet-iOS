//
//  Content.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/05/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

final class Content: Object {

    @objc dynamic var name = ""
    @objc dynamic var calorie = 0.0
    @objc dynamic var multiple = 0.0

    @objc dynamic var relativeX = 0.0
    @objc dynamic var relativeY = 0.0

    required convenience init(relativeX: Double, relativeY: Double) {
        self.init()
        self.relativeX = relativeX
        self.relativeY = relativeY
    }
}

extension Reactive where Base: Content {

    var saveName: Binder<String> {
        return Binder(base, scheduler: CurrentThreadScheduler.instance) { me, name in
            let realm = try! Realm()
            try! realm.write {
                me.name = name
            }
        }
    }

    var saveCalorie: Binder<Double> {
        return Binder(base, scheduler: CurrentThreadScheduler.instance) { me, calorie in
            let realm = try! Realm()
            try! realm.write {
                me.calorie = calorie
            }
        }
    }

    var saveMultiple: Binder<Double> {
        return Binder(base, scheduler: CurrentThreadScheduler.instance) { me, multiple in
            let realm = try! Realm()
            try! realm.write {
                me.calorie = multiple
            }
        }
    }
}
