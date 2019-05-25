//
//  Meal.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/05/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

final class Meal: Object {

    @objc dynamic var imagePath = ""
    let contents = List<Content>()
    @objc dynamic var date = Date()

    required convenience init(imagePath: String) {
        self.init()
        self.imagePath = imagePath
    }
}

extension Reactive where Base: Meal {

    var addContent: Binder<Content> {
        return Binder(base, scheduler: CurrentThreadScheduler.instance) { me, content in
            let realm = try! Realm()
            try! realm.write {
                me.contents.append(content)
            }
        }
    }
}
