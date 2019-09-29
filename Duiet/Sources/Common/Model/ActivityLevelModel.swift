//
//  ActivityLevelModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/09/28.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift
import RxCocoa
import RxRealm
import RxRelay
import RxSwift

protocol ActivityLevelModelInput {
    var add: AnyObserver<ActivityLevel> { get }
}

protocol ActivityLevelModelOutput {
    var activityLevel: Observable<ActivityLevel> { get }
}

protocol ActivityLevelModelProtocol {
    var input: ActivityLevelModelInput { get }
    var output: ActivityLevelModelOutput { get }
}

final class ActivityLevelModel: ActivityLevelModelProtocol {
    static let shared = ActivityLevelModel()

    let input: ActivityLevelModelInput
    let output: ActivityLevelModelOutput

    private let disposeBag = DisposeBag()

    init(repository: ActivityLevelRepositoryProtocol = ActivityLevelRepository.shared) {
        let add = PublishRelay<ActivityLevel>()
        input = Input(add: add.asObserver())

        let activityLevel = repository.find()
            .compactMap { $0.first }
        output = Output(activityLevel: activityLevel)

        add
            .subscribe(onNext: {
                repository.add(activityLevel: $0)
            })
            .disposed(by: disposeBag)
    }
}

extension ActivityLevelModel {
    struct Input: ActivityLevelModelInput {
        let add: AnyObserver<ActivityLevel>
    }

    struct Output: ActivityLevelModelOutput {
        let activityLevel: Observable<ActivityLevel>
    }
}
