//
//  RealmBaseModel.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/06/26.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

class RealmBaseModel: NSObject {

    let realm: Realm
    let disposeBag = DisposeBag()

    override init() {
        realm = try! Realm()
    }
}
