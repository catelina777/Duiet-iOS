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

protocol MonthModelProtocol {
    var changeData: PublishRelay<RealmChangeset?> { get }
    var days: BehaviorRelay<[Day]> { get }
}

final class MonthModel: RealmBaseModel, MonthModelProtocol {

    let changeData = PublishRelay<RealmChangeset?>()
    let days = BehaviorRelay<[Day]>(value: [])

    let repository: MonthRepositoryProtocol

    init(repository: MonthRepositoryProtocol) {
        self.repository = repository
        super.init()

        let dayResults = repository.findAll()
        observe(dayResults: dayResults)
    }

    private func observe(dayResults: Results<Day>) {
        Observable.array(from: dayResults)
            .subscribe(onNext: { [weak self] days in
                guard let self = self else { return }
                self.days.accept(days)
            })
            .disposed(by: disposeBag)
    }

    private func observe(monthObject: Month) {
        Observable.from(object: monthObject)
            .subscribe(onNext: { [weak self] month in
                guard let self = self else { return }
                let days = month.days.toArray()
                self.days.accept(days)
            })
            .disposed(by: disposeBag)
    }
}
