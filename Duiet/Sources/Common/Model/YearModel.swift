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

protocol YearModelProtocol {
    var months: BehaviorRelay<[Month]> { get }
}

final class YearModel: YearModelProtocol {

    let months = BehaviorRelay<[Month]>(value: [])

    private let repository: YearRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(repository: YearRepositoryProtocol) {
        self.repository = repository

        let monthResults = repository.find()
        observe(monthResults: monthResults)
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
