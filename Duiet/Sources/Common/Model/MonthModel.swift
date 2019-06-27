//
//  MonthModel.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/06/26.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RealmSwift
import RxRealm

final class MonthModel: RealmBaseModel {

    let changeData = PublishRelay<RealmChangeset?>()
    let days = BehaviorRelay<[Day]>(value: [])

    override init() {
        super.init()

        let dayResult = find()
        observe(dayResult: dayResult)
    }

    private func find() -> Results<Day> {
        return realm.objects(Day.self).sorted(byKeyPath: "createdAt")
    }

    private func observe(dayResult: Results<Day>) {
        Observable.array(from: dayResult)
            .subscribe(onNext: { [weak self] days in
                guard let self = self else { return }
                self.days.accept(days)
            })
            .disposed(by: disposeBag)
    }
}
