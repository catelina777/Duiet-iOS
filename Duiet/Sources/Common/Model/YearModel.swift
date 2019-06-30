//
//  YearModel.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/06/27.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import RxRealm
import RxRelay

final class YearModel: RealmBaseModel {

    static let shared = YearModel()

    let months = BehaviorRelay<[Month]>(value: [])

    override init() {
        super.init()
        let monthResults = find()
        observe(monthResults: monthResults)
    }

    func find() -> Results<Month> {
        let monthResults = realm.objects(Month.self).sorted(byKeyPath: "createdAt")
        return monthResults
    }

    func observe(monthResults: Results<Month>) {
        Observable.array(from: monthResults)
            .subscribe(onNext: { [weak self] months in
                guard let self = self else { return }
                self.months.accept(months)
            })
            .disposed(by: disposeBag)
    }
}
