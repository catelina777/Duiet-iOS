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
    private let month: BehaviorRelay<Month?>

    lazy var title: String = {
        if let month = month.value {
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
        self.month = BehaviorRelay<Month?>(value: month)

        if let month = month {
            repository.find(month: month)
                .map { $0.days.toArray() }
                .bind(to: days)
                .disposed(by: disposeBag)
        } else {
            repository.findAll()
                .map { $0.toArray() }
                .bind(to: days)
                .disposed(by: disposeBag)
        }
    }
}
