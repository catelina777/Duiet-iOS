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

final class MonthModel: MonthModelProtocol {

    let changeData = PublishRelay<RealmChangeset?>()
    let days = BehaviorRelay<[Day]>(value: [])

    private let repository: MonthRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(month: Month? = nil, repository: MonthRepositoryProtocol) {
        self.repository = repository

        if let month = month {
            let monthObject = repository.find(month: month)
            observe(monthObject: monthObject)
        } else {
            let dayResults = repository.findAll()
            observe(dayResults: dayResults)
        }
    }

    private func observe(dayResults: Results<Day>) {
        Observable.array(from: dayResults)
            .subscribe(onNext: { [weak self] days in
                guard let self = self else { return }
                self.days.accept(days)
            })
            .disposed(by: disposeBag)
    }

    private func observe(monthObject: Month?) {
        guard let monthObject = monthObject else { return }
        Observable.from(object: monthObject)
            .subscribe(onNext: { [weak self] month in
                guard let self = self else { return }
                let days = month.days.toArray()
                self.days.accept(days)
            })
            .disposed(by: disposeBag)
    }
}
