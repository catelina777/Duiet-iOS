//
//  DaysModel.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/06/26.
//  Copyright © 2019 Duiet. All rights reserved.
//

import Foundation
import RealmSwift
import RxRealm
import RxRelay
import RxSwift

protocol DaysModelProtocol {
    var changeData: PublishRelay<RealmChangeset?> { get }
    var days: BehaviorRelay<[Day]> { get }
    var title: String { get }
}

final class DaysModel: DaysModelProtocol {
    let changeData = PublishRelay<RealmChangeset?>()
    let days = BehaviorRelay<[Day]>(value: [])
    private let _month: BehaviorRelay<Month?>

    lazy var title: String = {
        if let month = _month.value {
            return month.createdAt.toYearMonthString()
        } else {
            return SceneType.days.title
        }
    }()

    private let repository: DaysRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(repository: DaysRepositoryProtocol = DaysRepository.shared,
         month: Month? = nil) {
        self.repository = repository
        _month = BehaviorRelay<Month?>(value: month)

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
                guard let me = self else { return }
                me.days.accept(days)
            })
            .disposed(by: disposeBag)
    }

    private func observe(monthObject: Month?) {
        guard let monthObject = monthObject else { return }
        Observable.from(object: monthObject)
            .subscribe(onNext: { [weak self] month in
                guard let me = self else { return }
                let days = month.days.toArray()
                me.days.accept(days)
            })
            .disposed(by: disposeBag)
    }
}
